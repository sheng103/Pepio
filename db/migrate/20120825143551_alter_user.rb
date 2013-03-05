class AlterUser < ActiveRecord::Migration
  def up
    execute "alter table users add column country_id int(10)"
    execute "update users set country='UG' where country='AU'"
    execute "update users set country_id=IF(country='TZ', 1, 2)"
    execute "alter table users drop column country"
  end

  def down
  end
end
