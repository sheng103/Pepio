class AlterUserDropBalance < ActiveRecord::Migration
  def up
    execute "alter table users drop column balance"
  end

  def down
  end
end
