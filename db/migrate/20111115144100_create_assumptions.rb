class CreateAssumptions < ActiveRecord::Migration
  def change
    create_table :assumptions do |t|
      t.text        :name,      :null => false
      t.text        :category,  :null => false
      t.text        :label,     :null => false
      t.text        :units,     :null => false
      t.integer     :value,     :null => false
      t.timestamps
    end
  end
end
