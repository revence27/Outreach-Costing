class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.text        :name, :null => false
      t.integer     :region_id
      t.timestamps
    end
  end
end
