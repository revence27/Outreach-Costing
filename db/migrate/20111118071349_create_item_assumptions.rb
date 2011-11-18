class CreateItemAssumptions < ActiveRecord::Migration
  def change
    create_table :item_assumptions do |t|
      t.text        :name
      t.text        :category,  :null => false
      t.text        :section,  :null => false
      t.text        :label
      t.text        :units
      t.float       :value,     :null => false, :default => 0.0
      t.integer     :associated_item_id
      t.timestamps
    end
  end
end
