class User < ActiveRecord::Base
  def self.create_from_access_token(access_token)
    foursquare = Foursquare::Base.new(access_token)
    user = foursquare.users.find('self')

    if existing = User.find_by_foursquare_id(user.id)
      existing.access_token = access_token
      existing.save
    else
      create(
        access_token: access_token,
        foursquare_id: user.id
      )
    end
  end
end
