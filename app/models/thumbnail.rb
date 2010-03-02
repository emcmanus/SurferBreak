class Thumbnail < ActiveRecord::Base
  belongs_to :game    # Many thumbnails to one game
end
