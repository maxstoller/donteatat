class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :access_token
      t.string :foursquare_id
      t.string :phone_number

      t.timestamps
    end
  end
end
