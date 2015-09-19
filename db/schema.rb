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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150918182202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.text     "biography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "portrait"
  end

  create_table "books", force: :cascade do |t|
    t.string   "title",                         null: false
    t.string   "cover"
    t.text     "short_description"
    t.text     "full_description"
    t.float    "price"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "category_id"
    t.integer  "author_id"
    t.integer  "average_rating",    default: 0
  end

  add_index "books", ["author_id"], name: "index_books_on_author_id", using: :btree
  add_index "books", ["category_id"], name: "index_books_on_category_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.text     "note",       null: false
    t.integer  "rating",     null: false
    t.integer  "status",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "book_id"
  end

  add_index "reviews", ["book_id"], name: "index_reviews_on_book_id", using: :btree
  add_index "reviews", ["status"], name: "index_reviews_on_status", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "shopper_addresses", force: :cascade do |t|
    t.string   "first_name",       null: false
    t.string   "last_name",        null: false
    t.string   "street",           null: false
    t.string   "city",             null: false
    t.string   "zip",              null: false
    t.string   "phone",            null: false
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "type"
    t.integer  "country_id",       null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "shopper_addresses", ["addressable_id", "addressable_type", "type"], name: "address_addressable_id_addressable_type_type", using: :btree
  add_index "shopper_addresses", ["country_id"], name: "index_shopper_addresses_on_country_id", using: :btree

  create_table "shopper_countries", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "shopper_countries", ["name"], name: "index_shopper_countries_on_name", unique: true, using: :btree

  create_table "shopper_credit_cards", force: :cascade do |t|
    t.string   "number",           null: false
    t.integer  "expiration_month", null: false
    t.integer  "expiration_year",  null: false
    t.integer  "cvv",              null: false
    t.integer  "order_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "shopper_credit_cards", ["order_id"], name: "index_shopper_credit_cards_on_order_id", using: :btree

  create_table "shopper_deliveries", force: :cascade do |t|
    t.string   "name",       null: false
    t.float    "price",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopper_order_items", force: :cascade do |t|
    t.integer  "quantity",     null: false
    t.string   "product_type", null: false
    t.integer  "product_id",   null: false
    t.integer  "order_id",     null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "shopper_order_items", ["order_id"], name: "index_shopper_order_items_on_order_id", using: :btree
  add_index "shopper_order_items", ["product_type", "product_id"], name: "index_shopper_order_items_on_product_type_and_product_id", using: :btree

  create_table "shopper_orders", force: :cascade do |t|
    t.integer  "state",         null: false
    t.integer  "customer_id"
    t.string   "customer_type"
    t.integer  "delivery_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "shopper_orders", ["customer_id", "customer_type"], name: "index_shopper_orders_on_customer_id_and_customer_type", using: :btree
  add_index "shopper_orders", ["delivery_id"], name: "index_shopper_orders_on_delivery_id", using: :btree
  add_index "shopper_orders", ["state"], name: "index_shopper_orders_on_state", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_admin",               default: false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "users_wishes", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "book_id"
  end

  add_index "users_wishes", ["user_id", "book_id"], name: "index_users_wishes_on_user_id_and_book_id", using: :btree

  create_table "wishes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "wishes", ["book_id"], name: "index_wishes_on_book_id", using: :btree
  add_index "wishes", ["user_id"], name: "index_wishes_on_user_id", using: :btree

  add_foreign_key "books", "authors"
  add_foreign_key "books", "categories"
  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "users"
  add_foreign_key "wishes", "books"
  add_foreign_key "wishes", "users"
end
