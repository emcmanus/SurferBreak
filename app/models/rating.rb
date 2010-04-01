# create_table "profilePhotos", :force => true do |t|
#   t.integer "user_id"
#   t.string  "storage_object_id", :null => false
#   t.string  "original_filename", :null => false
#   t.integer "width",             :null => false
#   t.integer "height",            :null => false
# end

class Rating < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
end
