class PagesController < ApplicationController
  def callback
    foursquare = Foursquare::Base.new(KEYS[:foursquare][:client_id], KEYS[:foursquare][:client_secret])
    access_token = foursquare.access_token(params[:code], 'http://donteat.at/callback')
    User.create_from_access_token(access_token)
  end
end
