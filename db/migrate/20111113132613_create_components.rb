class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.text          :name
      t.timestamps
    end
  end
end
