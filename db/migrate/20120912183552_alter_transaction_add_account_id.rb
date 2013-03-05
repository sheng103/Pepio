class AlterTransactionAddAccountId < ActiveRecord::Migration
  def up
    execute "alter table transactions add column account_id int(10)"
    execute "alter table transactions add column countrer_account_id int(10)"
  end

  def down
  end
end