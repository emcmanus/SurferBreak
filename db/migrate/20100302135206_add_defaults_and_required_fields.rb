class AddDefaultsAndRequiredFields < ActiveRecord::Migration
  def self.up
    
    # Games, defaults
    change_column :games, :avg_rating, :float, :default => 0
    change_column :games, :num_ratings, :integer, :default => 0
    change_column :games, :ranked_value, :float, :default => 0
    change_column :games, :deleted, :boolean, :default => false
    change_column :games, :play_count, :integer, :default => 0
    change_column :games, :removed, :boolean, :default => false
    change_column :games, :is_adult, :boolean, :default => false
    
    # Games, required
    change_column :games, :platform, :string, :null => false
    
    # Ratings
    change_column :ratings, :rating, :integer, :null => false
    
    # Thumbnails
    change_column :thumbnails, :width, :integer, :null => false
    change_column :thumbnails, :height, :integer, :null => false
    change_column :thumbnails, :path, :string, :null => false
    
    # Feedbacks
    change_column :feedbacks, :body, :string, :null => false
    
  end

  def self.down
  end
end
