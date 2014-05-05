class Inspection < ActiveRecord::Base
  before_create :clean_data
  after_create :standardize_address

  BOROUGHS = %w(Manhattan The\ Bronx Brooklyn Queens Staten\ Island')

  def self.create_or_update_from_row_if_newer(row)
    if existing = Inspection.find_by_camis(row[0])
      if existing.date < DateTime.parse(row[8])
        existing.update_date_and_score(row[8], row[11].to_i)
      end
    else
      Inspection.create(
        camis:    row[0],
        dba:      row[1],
        borough:  BOROUGHS[row[2].to_i - 1],
        building: row[3],
        street:   row[4],
        zip_code: row[5],
        phone:    row[6],
        date:     row[8],
        score:    row[11].to_i
      )
    end
  end

  def update_date_and_score(date, score)
    self.date = date
    self.score = score

    save
  end

  def failed?
    score >= 28
  end

  private

  def clean_data
    [:dba, :building, :street].each do |attribute|
      value = self.read_attribute(attribute)
        .strip
        .downcase
        .gsub("'", '')
      self.send("#{attribute}=", value)
    end
  end

  def standardize_address
    query = "#{building} #{street} #{borough}, ny #{zip_code}"
    result = Geocoder.search(query)
    self.standardized_address = result.first.address unless result.empty?

    save
  end
  handle_asynchronously :standardize_address
end
