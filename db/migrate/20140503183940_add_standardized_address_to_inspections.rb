class AddStandardizedAddressToInspections < ActiveRecord::Migration
  def change
    add_column :inspections, :standardized_address, :string
  end
end
