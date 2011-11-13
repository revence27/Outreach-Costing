class CreateParishes < ActiveRecord::Migration
  def change
    create_table :parishes do |t|
      t.text        :name, :null => false
      t.integer     :sub_county_id
      t.timestamps
    end
  end
end
