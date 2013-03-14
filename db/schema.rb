# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130306145202) do

  create_table "accounts", :force => true do |t|
    t.string   "account_type",       :limit => 30
    t.string   "name",               :limit => 50
    t.integer  "company_id",                                                                         :null => false
    t.integer  "country_id",                                                                         :null => false
    t.decimal  "balance",                          :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.boolean  "deleted",                                                         :default => false
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts_old", :force => true do |t|
    t.string   "account_type",       :limit => 30
    t.string   "name",               :limit => 50
    t.integer  "company_id",                                                                         :null => false
    t.integer  "country_id",                                                                         :null => false
    t.decimal  "balance",                          :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.boolean  "deleted",                                                         :default => false
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name",               :limit => 50
    t.boolean  "deleted",                          :default => false
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
  end

  create_table "countries", :force => true do |t|
    t.string   "name",               :limit => 50
    t.string   "code",               :limit => 2
    t.boolean  "deleted",                          :default => false
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interfaces", :force => true do |t|
    t.string   "screen",     :limit => 20,  :default => ""
    t.string   "element",    :limit => 60
    t.string   "language",   :limit => 20,  :default => ""
    t.string   "text",       :limit => 100, :default => ""
    t.boolean  "deleted",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interfaces1", :force => true do |t|
    t.string   "screen",     :limit => 20,  :default => ""
    t.string   "element",    :limit => 60
    t.string   "language",   :limit => 20,  :default => ""
    t.string   "text",       :limit => 100, :default => ""
    t.boolean  "deleted",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.boolean  "deleted",            :default => false
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "transactions", :force => true do |t|
    t.decimal  "debit",                              :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "credit",                             :precision => 10, :scale => 2, :default => 0.0
    t.string   "transaction_type",     :limit => 40,                                                   :null => false
    t.integer  "user_id",                                                                              :null => false
    t.string   "phone_number",         :limit => 20
    t.integer  "counter_user_id",                                                                      :null => false
    t.string   "counter_phone_number", :limit => 20
    t.boolean  "deleted",                                                           :default => false
    t.integer  "created_by_user_id",                                                                   :null => false
    t.integer  "updated_by_user_id",                                                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.integer  "counter_account_id"
  end

  create_table "user_companies", :force => true do |t|
    t.integer  "user_id",                               :null => false
    t.integer  "company_id",                            :null => false
    t.boolean  "deleted",            :default => false
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_phones", :force => true do |t|
    t.integer  "user_id",                                       :null => false
    t.string   "phone_number", :limit => 20
    t.boolean  "deleted",                    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email_address",      :limit => 30,                    :null => false
    t.string   "surname",            :limit => 20
    t.string   "first_name",         :limit => 20
    t.string   "second_name",        :limit => 20
    t.string   "language",           :limit => 20
    t.boolean  "deleted",                          :default => false
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "village",            :limit => 50
    t.string   "voter_id",           :limit => 50
    t.integer  "country_id"
    t.integer  "role_id"
    t.integer  "company_id"
    t.integer  "account_id"
    t.string   "district",           :limit => 50
    t.string   "buyer_group",        :limit => 50
    t.string   "gender"
    t.string   "shopkepper"
    
    t.decimal  "balance",                           :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "users1", :force => true do |t|
    t.string   "email_address",       :limit => 30,                                                   :null => false
    t.string   "surname",             :limit => 20
    t.string   "first_name",          :limit => 20
    t.string   "second_name",         :limit => 20
    t.string   "language",            :limit => 20
    t.decimal  "balance",                           :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.boolean  "deleted",                                                          :default => false
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "village",             :limit => 50
    t.string   "voter_id",            :limit => 50
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "country_id"
    t.integer  "role_id"
    t.integer  "company_id"
    t.integer  "account_id"
  end

end
