class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :games
  belongs_to :user_photos # default photo
end
