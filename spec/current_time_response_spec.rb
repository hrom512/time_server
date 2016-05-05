require 'spec_helper'
require_relative '../lib/current_time_response'

describe CurrentTimeResponse do
  let(:current_time) { double('current_time') }
  let(:cities) { ['Moscow', 'New York', 'Invalid'] }

  let(:response) { described_class.new(current_time, cities) }

  let(:utc_time) { Time.utc(2016, 5, 1, 12, 15, 1) }     # 2016.05.01 12:15:01 (UTC)
  let(:moscow_time) { Time.utc(2016, 5, 1, 15, 15, 1) }  # 2016.05.01 15:15:01 (+03:00)
  let(:new_york_time) { Time.utc(2016, 5, 1, 8, 15, 1) } # 2016.05.01 08:15:01 (-04:00)

  before do
    allow(current_time).to receive(:utc).and_return(utc_time)
    allow(current_time).to receive(:in_city).with('Moscow').and_return(moscow_time)
    allow(current_time).to receive(:in_city).with('New York').and_return(new_york_time)
    allow(current_time).to receive(:in_city).with('Invalid').and_raise(CurrentTime::TimezoneNotFound,
                                                                       'Timezone not found')
  end

  describe '#build' do
    let(:response_content) do
      content = 'UTC: 2016-05-01 12:15:01'
      content << "\nMoscow: 2016-05-01 15:15:01"
      content << "\nNew York: 2016-05-01 08:15:01"
      content << "\nInvalid: Timezone not found"
      content
    end

    it { expect(response.build).to eq(response_content) }
  end
end
