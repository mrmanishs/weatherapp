class WeatherController < ApplicationController

  # API key normally would be stored in some sort of secure store
  API_KEY = "JXM7S7Z4YXHJ3426QX3HGDFS5".freeze

  def index
    @location = params[:location]

    if @location.present?
      postal_code = Geocoder.search(@location).first.data['address']['postcode']
      @cached = Rails.cache.exist?(postal_code)

      @results = Rails.cache.fetch(postal_code, expires_in: 30.minutes) do
        weather(@location)
      end
    end
  end

  def weather(location)
    api_url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{URI.escape(location)}?unitGroup=us&key=#{API_KEY}&contentType=json"

    uri = URI(api_url)
    response = JSON.parse(Net::HTTP.get(uri))

    results = {
      "current_temp" => response['currentConditions']['temp']
    }

    results['forecast'] = {}
    

    response['days'].each {|day|
      results['forecast'][day['datetime']] = {}
      results['forecast'][day['datetime']]['current_temp'] = day['temp']
      results['forecast'][day['datetime']]['temp_min'] = day['tempmin']
      results['forecast'][day['datetime']]['temp_max'] = day['tempmax']
    }

    results
  end
end
