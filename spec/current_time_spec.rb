require 'timecop'
require 'spec_helper'
require_relative '../lib/current_time'

describe CurrentTime do
  before do
    Timecop.freeze(utc_time.getlocal)
  end

  after do
    Timecop.return
  end

  let(:utc_time) { Time.utc(2016, 5, 1, 12, 15, 1) }     # 2016.05.01 12:15:01 (UTC)
  let(:moscow_time) { Time.utc(2016, 5, 1, 15, 15, 1) }  # 2016.05.01 15:15:01 (+03:00)
  let(:new_york_time) { Time.utc(2016, 5, 1, 8, 15, 1) } # 2016.05.01 08:15:01 (-04:00)

  let(:current_time) { described_class.new }

  describe '#utc' do
    it { expect(current_time.utc).to eq(utc_time) }
  end

  describe '#in_city' do
    it { expect(current_time.in_city('Moscow')).to eq(moscow_time) }
    it { expect(current_time.in_city('New York')).to eq(new_york_time) }

    context 'with invalid city' do
      it 'raise error' do
        expect {
          current_time.in_city('Invalid')
        }.to raise_error(CurrentTime::TimezoneNotFound, 'Timezone not found')
      end
    end
  end
end
