class AlterUserAddRoleId < ActiveRecord::Migration
  def up
    execute "alter table users add column role_id int(10)"
    execute "update users set role_id='5' where user_type='User'"
    execute "update users set role_id='1' where user_type='Admin'"
    execute "alter table users drop column user_type"
  end

  def down
  end
end
