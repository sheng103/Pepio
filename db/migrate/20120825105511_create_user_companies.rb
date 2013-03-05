class CreateUserCompanies < ActiveRecord::Migration
  def up
    create_table :user_companies do |t|

      t.integer :user_id,      :null => false
      t.integer :company_id,   :null => false
      t.boolean :deleted,      :default => false
      t.integer :created_by_user_id
      t.integer :updated_by_user_id
      
      t.timestamps
    end
  end

  def down
    drop_table :user_companies
  end
end