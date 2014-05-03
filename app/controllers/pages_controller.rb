class PagesController < ApplicationController
  def callback
    url = "https://foursquare.com/oauth2/access_token
      ?client_id=#{KEYS[:foursquare][:client_id]}
      &client_secret=#{KEYS[:foursquare][:client_secret]}
      &grant_type=authorization_code
      &redirect_uri=http://donteat.at/callback
      &code=#{params[:code]}"
    response = HTTParty.get(url).parsed_response

    User.create_from_access_token(response['access_token'])
  end
end
