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

ActiveRecord::Schema.define(version: 20160623174818) do

  create_table "collaborators", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "dictionary_id"
    t.boolean  "can_create_entries"
    t.boolean  "can_change_entries"
    t.boolean  "can_delete_entries"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "collaborators", ["dictionary_id"], name: "index_collaborators_on_dictionary_id"
  add_index "collaborators", ["user_id"], name: "index_collaborators_on_user_id"

  create_table "dictionaries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
    t.boolean  "public"
    t.integer  "user_id"
  end

  add_index "dictionaries", ["user_id"], name: "index_dictionaries_on_user_id"

  create_table "entries", force: :cascade do |t|
    t.integer  "dictionary_id"
    t.string   "content"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "entries", ["dictionary_id"], name: "index_entries_on_dictionary_id"

  create_table "entries_lemmas", id: false, force: :cascade do |t|
    t.integer "entry_id"
    t.integer "lemma_id"
  end

  create_table "lemmas", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recordings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "recordings", ["entry_id"], name: "index_recordings_on_entry_id"
  add_index "recordings", ["user_id"], name: "index_recordings_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "remember_digest"
  end

end
