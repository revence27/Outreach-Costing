class CreateHealthUnits < ActiveRecord::Migration
  def change
    create_table :health_units do |t|
      t.text          :name
      t.integer       :code
      t.text          :owner
      t.text          :level
      t.text          :status
      t.integer       :parish_id
      t.timestamps
    end
  end
end
