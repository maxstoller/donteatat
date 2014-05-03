class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
      t.string   :camis
      t.string   :dba
      t.string   :borough
      t.string   :building
      t.string   :street
      t.string   :zip_code
      t.string   :phone
      t.datetime :date
      t.integer  :score

      t.timestamps
    end

    add_index :inspections, :camis
  end
end
