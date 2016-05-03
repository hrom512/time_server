require_relative 'current_time'

# Current time response builder
class CurrentTimeResponse
  attr_reader :current_time, :cities

  def initialize(current_time, cities)
    @current_time = current_time
    @cities = cities
  end

  def build
    lines = []
    lines << utc_time

    cities.each do |city|
      lines << city_time(city)
    end

    lines.join("\n")
  end

  private

  def utc_time
    build_line('UTC', current_time.utc)
  end

  def city_time(city)
    time =
      begin
        current_time.in_city(city)
      rescue CurrentTime::TimezoneNotFound => e
        e.message
      end
    build_line(city, time)
  end

  def build_line(title, time)
    time = time.strftime('%Y-%m-%d %H:%M:%S') if time.is_a?(Time)
    "#{title}: #{time}"
  end
end
