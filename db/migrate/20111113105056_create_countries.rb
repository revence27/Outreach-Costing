class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.text        :name, :null => false, :default => 'Uganda'
      t.timestamps
    end
  end
end
