class AlterPhoneToString < ActiveRecord::Migration
  def up
    execute "alter table user_phones change phone_number phone_number varchar(20) "
    execute "alter table transactions change phone_number phone_number varchar(20) "
    execute "alter table transactions change counter_phone_number counter_phone_number varchar(20) "
  end

  def down
  end
end
