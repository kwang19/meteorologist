require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    @street_address_without_spaces = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the variable @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the variable @street_address_without_spaces.
    # ==========================================================================

    @google_address = @street_address_without_spaces.gsub("%20", "+")

    @url = "http://maps.googleapis.com/maps/api/geocode/json?address=" + @google_address

    @parsed_data = JSON.parse(open(@url).read)

    @lat = @parsed_data["results"][0]["geometry"]["location"]["lat"]

    @lng = @parsed_data["results"][0]["geometry"]["location"]["lng"]

    @url = "https://api.darksky.net/forecast/a744c04ced24f90ebb67febc8d97bfa5/"+@lat.to_s+","+@lng.to_s

    @parsed_data = JSON.parse(open(@url).read)

    @current_temperature = @parsed_data["currently"]["temperature"]

    @current_summary = @parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = @parsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = @parsed_data["hourly"]["summary"]

    @summary_of_next_several_days = @parsed_data["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
