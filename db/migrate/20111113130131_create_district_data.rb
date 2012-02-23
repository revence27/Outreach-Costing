class CreateDistrictData < ActiveRecord::Migration
  def change
    create_table :district_data do |t|
      t.integer           :populated_location_id
      t.string            :populated_location_type
      t.integer           :population
      t.integer           :under_one
      t.integer           :one_to_four
      t.integer           :pregnancies
      t.integer           :number_sub_counties
      t.integer           :number_parishes
      t.integer           :number_venues
      # I assume other things will fit here.
      t.timestamps
    end
  end
end
