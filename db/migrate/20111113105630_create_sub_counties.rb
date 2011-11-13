class CreateSubCounties < ActiveRecord::Migration
  def change
    create_table :sub_counties do |t|
      t.text        :name, :null => false
      t.integer     :district_id
      t.timestamps
    end
  end
end
