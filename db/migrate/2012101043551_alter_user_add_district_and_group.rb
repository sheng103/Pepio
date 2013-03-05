class AlterUserAddDistrictAndGroup < ActiveRecord::Migration
  def up
    execute "alter table users add column district varchar(50)"
    execute "alter table users add column buyer_group varchar(50)"
  end

  def down
  end
end
