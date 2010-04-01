# create_table "feedbacks", :force => true do |t|
#   t.string   "email"
#   t.string   "body",           :null => false
#   t.string   "submission_url"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "user_id"
# end

class Feedback < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :body
end
