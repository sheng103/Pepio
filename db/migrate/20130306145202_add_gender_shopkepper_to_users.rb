class AddGenderShopkepperToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender,     :string
    add_column :users, :shopkepper, :string
  end
end
