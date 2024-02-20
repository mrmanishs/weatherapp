require 'rails_helper'

RSpec.describe "WeatherController", type: :request do
  before do
    @location = 'springfield,nj'
  end

  describe "GET weather/index" do
    before do
      get "/weather/?location=#{@location}"
    end

    it 'returns results with successful status code' do
      expect(response.status).to eq(200)
    end
  end
end
