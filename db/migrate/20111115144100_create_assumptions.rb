class CreateAssumptions < ActiveRecord::Migration
  def change
    create_table :assumptions do |t|
      t.text        :name,      :null => false
      t.text        :category,  :null => false
      t.text        :label,     :null => false
      t.text        :units,     :null => false
      t.float       :value,     :null => false, :default => 0.0
      t.integer     :activity_item_id
      t.timestamps
    end
  end
end
