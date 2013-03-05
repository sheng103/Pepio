class AlterUserAddCompanyId < ActiveRecord::Migration
  def up
    execute "alter table users add column company_id int(10)"
    execute "alter table users add column account_id int(10)"
  end

  def down
  end
end
