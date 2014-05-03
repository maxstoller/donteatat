require 'net/http'
require 'zip'
require 'csv'

class UpdateInspectionsJob
  DATASET_PATH = '
    /html/doh/downloads/zip/bigapps/dohmh_restaurant-inspections_002.zip'

  def download
    system "mkdir tmp/#{Process.pid} -p"

    Net::HTTP.start('www.nyc.gov') do |http|
      file = open("tmp/#{Process.pid}/dataset.zip", 'wb')

      http.request_get(DATASET_PATH) do |response|
        response.read_body { |segment| file.write(segment) }
      end

      file.close
    end
  end

  def unzip
    Zip::File.open("tmp/#{Process.pid}/dataset.zip") do |zip|
      zip.extract('WebExtract.txt',
        "#{Rails.root}/tmp/#{Process.pid}/WebExtract.txt")
    end
  end

  def parse
    dataset = File.open("tmp/#{Process.pid}/WebExtract.txt")

    dataset.each do |line|
      row = CSV.parse_line(line) rescue nil
      next if row == nil || row[0] == 'CAMIS'

      Inspection.create_or_update_from_row_if_newer(row)
    end

    dataset.close
  end

  def perform
    download; unzip; parse
  end
end
