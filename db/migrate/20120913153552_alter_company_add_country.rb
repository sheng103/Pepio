class AlterCompanyAddCountry < ActiveRecord::Migration
  def up
    execute "alter table companies add column country_id integer(11)"
    execute "update companies set country_id=1 where id=1"
    execute "update companies set country_id=2 where id=2"
  end

  def down
  end
end
