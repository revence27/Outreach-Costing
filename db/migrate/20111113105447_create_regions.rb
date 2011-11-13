class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.text        :name, :null => false
      t.integer     :country_id
      t.timestamps
    end
  end
end
