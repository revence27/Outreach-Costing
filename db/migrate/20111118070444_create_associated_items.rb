class CreateAssociatedItems < ActiveRecord::Migration
  def change
    create_table :associated_items do |t|
      t.text        :name
      t.text        :description
      t.integer     :activity_item_id
      t.timestamps
    end
  end
end
