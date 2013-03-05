class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.integer :code      
      t.boolean :deleted,       :default => false
      t.integer :created_by_user_id
      t.integer :updated_by_user_id


      t.timestamps
    end
  end
end
