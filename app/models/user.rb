class User < ActiveRecord::Base
  def self.create_from_access_token(access_token)
    url = "https://api.foursquare.com/v2/users/self
      ?oauth_token=#{access_token}
      &v=20140503"
    response      = HTTParty.get(url).parsed_response['response']
    foursquare_id = response['user']['id']
    phone_number  = response['user']['contact']['phone']

    if user = User.find_by_foursquare_id(foursquare_id)
      user.access_token = access_token
      user.phone_number = phone_number
      user.save
    else
      create(
        access_token:  access_token,
        foursquare_id: foursquare_id,
        phone_number:  phone_number
      )
    end
  end
end
