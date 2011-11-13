class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text        :username, :null => false
      t.text        :sha1_pass, :null => false
      t.text        :sha1_salt, :null => false
      t.boolean     :is_admin, :null => false, :default => false
      t.timestamps
    end
  end
end
