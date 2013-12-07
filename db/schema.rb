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

ActiveRecord::Schema.define(version: 20131207182105) do

  create_table "book_possessions", force: true do |t|
    t.integer  "book_id"
    t.integer  "donor"
    t.integer  "holder"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transfer_count"
    t.string   "status"
  end

  add_index "book_possessions", ["book_id"], name: "index_book_possessions_on_book_id"
  add_index "book_possessions", ["donor"], name: "index_book_possessions_on_donor"
  add_index "book_possessions", ["holder"], name: "index_book_possessions_on_holder"
  add_index "book_possessions", ["status"], name: "index_book_possessions_on_status"

  create_table "books", force: true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "author"
    t.string   "author_infor"
    t.string   "image"
    t.string   "summary"
    t.string   "publisher"
    t.string   "pubdate"
    t.integer  "num"
    t.string   "isbn"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tag"
  end

  add_index "books", ["isbn"], name: "index_books_on_isbn"
  add_index "books", ["title"], name: "index_books_on_title"

  create_table "borroweds", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "borroweds", ["book_id"], name: "index_borroweds_on_book_id"
  add_index "borroweds", ["user_id"], name: "index_borroweds_on_user_id"

  create_table "donateds", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "donated_count"
    t.integer  "onhand_count"
  end

  add_index "donateds", ["book_id"], name: "index_donateds_on_book_id"
  add_index "donateds", ["user_id"], name: "index_donateds_on_user_id"

  create_table "pending_books", force: true do |t|
    t.integer  "book_possession_id"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pending_books", ["book_possession_id"], name: "index_pending_books_on_book_possession_id"
  add_index "pending_books", ["receiver_id"], name: "index_pending_books_on_receiver_id"
  add_index "pending_books", ["sender_id"], name: "index_pending_books_on_sender_id"
  add_index "pending_books", ["status"], name: "index_pending_books_on_status"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "wishes", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wishes", ["book_id"], name: "index_wishes_on_book_id"
  add_index "wishes", ["user_id"], name: "index_wishes_on_user_id"

end
