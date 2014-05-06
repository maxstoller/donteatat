class CheckinJob < Struct.new(:checkin)
  def valid_ny_checkin?(checkin)
    checkin['type'] == 'checkin' &&
    (checkin['venue']['location']['state'] == 'NY' ||
    checkin['venue']['location']['state'] == 'New York')
  end

  def perform
    return false unless valid_ny_checkin?(checkin)
    # return false if User.find_by_foursquare_id(checkin['user']['id']).nil?

    user   = checkin['user']
    venue  = checkin['venue']
    dba    = venue['name'].strip.downcase.gsub("'", '')

    query = "#{venue['location']['address']} " +
            "#{venue['location']['city']}, " +
            "#{venue['location']['state']} " +
            "#{venue['location']['postalCode']}"
    result = Geocoder.search(query)
    return false if result.empty?
    standardized_address = result.first.address

    if inspection = Inspection.find_by_dba_and_standardized_address(dba, standardized_address)
      send_text_message(inspection, venue, user['contact']['phone']) if inspection.failed?
    end
  end

  def send_text_message(inspection, venue, phone_number)
    client = Twilio::REST::Client.new(
      KEYS[:twilio][:account_sid],
      KEYS[:twilio][:auth_token]
    )

    message = "Heads up! #{venue['name']} received #{inspection.score} violation " +
              "points on its #{inspection.date.strftime('%-m/%-d')} inspection. " +
              "That's not good. Love, DontEat.at."
    client.account.messages.create(
      from: '+15166287713',
      to:   "+1#{phone_number}",
      body: message
    )
  end
end
