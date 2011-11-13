class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.text        :name, :null => false
      t.timestamps
    end
  end
end
