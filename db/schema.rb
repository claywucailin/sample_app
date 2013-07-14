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

ActiveRecord::Schema.define(:version => 20130702050035) do

  create_table "addresses", :force => true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "zipcode"
    t.string   "street_address"
    t.integer  "region_id"
    t.string   "recipient"
    t.string   "tel"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "events", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "venue_id"
    t.text     "description"
    t.integer  "category_id"
    t.string   "type"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "region_id"
    t.string   "title",       :default => "", :null => false
  end

  create_table "images", :force => true do |t|
    t.string   "description"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  create_table "listings", :force => true do |t|
    t.integer  "split_type"
    t.integer  "seller_id"
    t.integer  "status"
    t.integer  "tickets_count"
    t.decimal  "total_amount"
    t.integer  "event_id"
    t.string   "section"
    t.string   "row"
    t.integer  "seat_type"
    t.integer  "split_divisor"
    t.integer  "available_tickets_count"
    t.decimal  "list_price"
    t.decimal  "net_price"
    t.decimal  "commission"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "master_data", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "type"
    t.integer  "parent_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "model_relationships", :force => true do |t|
    t.integer  "refer_from_id"
    t.string   "refer_from_type"
    t.integer  "refer_from_status"
    t.integer  "refer_to_id"
    t.string   "refer_to_type"
    t.integer  "refer_to_status"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "order_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "ticket_id"
    t.decimal  "selling_price"
    t.datetime "receipt_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "buyer_id"
    t.integer  "shipment_method"
    t.text     "shipment_address"
    t.datetime "payment_date"
    t.integer  "payment_method"
    t.decimal  "total_amount"
    t.datetime "shipment_date"
    t.integer  "status"
    t.decimal  "shipment_fee"
    t.decimal  "service_fee"
    t.decimal  "tickets_amount"
    t.integer  "seller_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "performers", :force => true do |t|
    t.string   "type"
    t.string   "name",        :default => ""
    t.string   "aka",         :default => ""
    t.text     "profiles"
    t.text     "description"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "event_id"
    t.string   "section"
    t.string   "row"
    t.string   "seat"
    t.integer  "listing_id"
    t.decimal  "list_price"
    t.decimal  "net_price"
    t.decimal  "commission"
    t.integer  "status"
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "tel"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
