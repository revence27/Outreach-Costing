class CreateVillages < ActiveRecord::Migration
  def change
    create_table :villages do |t|
      t.text        :name, :null => false
      t.integer     :parish_id
      t.timestamps
    end
  end
end
