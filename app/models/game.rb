class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :thumnail   # Default thumbnail
  
  has_many :ratings
end
