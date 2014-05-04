class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:receive]

  def callback
    url = "https://foursquare.com/oauth2/access_token" +
      "?client_id=#{KEYS[:foursquare][:client_id]}" +
      "&client_secret=#{KEYS[:foursquare][:client_secret]}" +
      "&grant_type=authorization_code" +
      "&redirect_uri=http://www.donteat.at/callback" +
      "&code=#{params[:code]}"
    response = HTTParty.get(url).parsed_response

    User.create_from_access_token(response['access_token'])
  end

  def receive
    Delayed::Job.enqueue(CheckinJob.new(JSON.parse(params[:checkin])))

    head :ok
  end
end
