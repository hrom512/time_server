require 'tzinfo'
require 'byebug'

# Current time for timezones
class CurrentTime
  # Error, which raised when timezone for city not found
  class TimezoneNotFound < StandardError
    def message
      'Timezone not found'
    end
  end

  class << self
    def tz_id_by_city(city)
      @tz_id_by_city ||=
        TZInfo::Timezone.all_identifiers.each_with_object({}) do |tz_id, result|
          city_name = tz_id.split('/')[-1]
          unless city_name.nil?
            city_name = city_name.tr('_', ' ')
            result[city_name] = tz_id
          end
        end
      @tz_id_by_city[city]
    end
  end

  attr_reader :utc

  def initialize
    @utc = Time.now.getgm
  end

  def in_city(city)
    tz_id = self.class.tz_id_by_city(city)
    raise TimezoneNotFound unless tz_id

    time_zone = TZInfo::Timezone.get(tz_id)
    time_zone.utc_to_local(utc)
  end
end
