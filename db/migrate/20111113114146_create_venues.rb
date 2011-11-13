class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.text          :name, :null => false
      t.integer       :district_id
      t.timestamps
    end
  end
end
