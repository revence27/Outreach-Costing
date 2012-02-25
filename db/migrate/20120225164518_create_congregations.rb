class CreateCongregations < ActiveRecord::Migration
  def change
    create_table :congregations do |t|
      t.text        :name
      t.integer     :health_unit_id
      t.integer     :populated_location_id
      t.text        :populated_location_text
      t.timestamps
    end
  end
end
