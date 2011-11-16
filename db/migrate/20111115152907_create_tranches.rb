class CreateTranches < ActiveRecord::Migration
  def change
    create_table :tranches do |t|
      t.text          :name
      t.text          :category
      t.integer       :assumption_id
      t.timestamps
    end
  end
end
