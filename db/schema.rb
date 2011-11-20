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

ActiveRecord::Schema.define(:version => 20111120044100) do

  create_table "branches", :force => true do |t|
    t.integer  "institution_id"
    t.string   "name"
    t.string   "id_no"
    t.string   "principal"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "pin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tipe"
  end

  create_table "clazzs", :force => true do |t|
    t.integer  "branch_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elements", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "startime"
    t.datetime "endtime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recurring"
    t.string   "description"
    t.date     "recurring_end"
  end

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.string   "ceo"
    t.string   "id_no"
    t.string   "registered_address"
    t.string   "city"
    t.string   "state"
    t.string   "pin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mark_rec_defns", :force => true do |t|
    t.string   "name"
    t.string   "subject_id_list"
    t.integer  "hash_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marks", :force => true do |t|
    t.integer  "section_id"
    t.integer  "test_id"
    t.integer  "student_id"
    t.float    "sub1"
    t.float    "sub2"
    t.float    "sub3"
    t.float    "sub4"
    t.float    "sub5"
    t.float    "sub6"
    t.float    "sub7"
    t.float    "sub8"
    t.float    "sub9"
    t.float    "sub10"
    t.float    "sub11"
    t.float    "sub12"
    t.float    "sub13"
    t.float    "sub14"
    t.float    "sub15"
    t.float    "total"
    t.integer  "rank"
    t.string   "grade"
    t.string   "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "arrears"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "periods", :force => true do |t|
    t.integer  "period_no"
    t.time     "starttime"
    t.time     "endtime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  create_table "profiles", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "password_digest"
    t.integer  "profile_type"
    t.integer  "profile_ptr"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "attendee_id"
    t.string   "attendee_type"
    t.integer  "event_id"
    t.integer  "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sec_33_2010-11_marks", :force => true do |t|
    t.float    "Maths"
    t.float    "Science"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sec_sub_maps", :force => true do |t|
    t.integer  "section_id"
    t.integer  "subject_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mark_column"
    t.float    "max_marks"
    t.float    "pass_marks"
  end

  create_table "sec_test_maps", :force => true do |t|
    t.integer  "section_id"
    t.integer  "test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "startdate"
    t.date     "enddate"
    t.integer  "event_id"
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.integer  "class_teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clazz_id"
  end

  create_table "student_contacts", :force => true do |t|
    t.integer  "student_id"
    t.string   "primary_email"
    t.string   "email"
    t.string   "mobile"
    t.string   "telephone"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.integer  "section_id"
    t.string   "name"
    t.string   "id_no"
    t.boolean  "female"
    t.date     "dob"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  create_table "teacher_contacts", :force => true do |t|
    t.integer  "teacher_id"
    t.string   "primary_email"
    t.string   "email"
    t.string   "mobile"
    t.string   "telephone"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", :force => true do |t|
    t.string   "id_no"
    t.string   "name"
    t.boolean  "female"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  create_table "tests", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  create_table "time_tables", :force => true do |t|
    t.integer  "section_id"
    t.integer  "period_no"
    t.integer  "monday"
    t.integer  "tuesday"
    t.integer  "wednesday"
    t.integer  "thursday"
    t.integer  "friday"
    t.integer  "saturday"
    t.integer  "sunday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
