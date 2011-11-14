class CreateActivityItems < ActiveRecord::Migration
  def change
    create_table :activity_items do |t|
      t.text        :name
      t.text        :description
      t.integer     :activity_id
      t.timestamps
    end
  end
end
