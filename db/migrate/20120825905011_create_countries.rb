class CreateCountries < ActiveRecord::Migration
  def up
    create_table :countries do |t|

      t.string  :name,  :limit => 50
      t.boolean :deleted,       :default => false
      t.integer :created_by_user_id
      t.integer :updated_by_user_id
      
      t.timestamps
    end
  end

  def down
    drop_table :countries
  end
end