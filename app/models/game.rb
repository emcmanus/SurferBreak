class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :thumbnail   # Default thumbnail
  
  has_many :ratings
end
