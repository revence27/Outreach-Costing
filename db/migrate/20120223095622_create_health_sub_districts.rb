class CreateHealthSubDistricts < ActiveRecord::Migration
  def change
    create_table :health_sub_districts do |t|
      t.text          :name
      t.integer       :district_id
      t.integer       :populated_location_id
      t.string        :populated_location_type
      t.timestamps
    end
  end
end
