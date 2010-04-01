class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      
      t.float     :avg_rating
      t.integer   :num_ratings
      t.float     :ranked_value
      t.boolean   :deleted
      t.boolean   :received_dmca_takedown
      t.integer   :play_count
      t.string    :platform
      t.text      :description
      t.string    :title
      t.boolean   :is_adult
      
      # File attributes
      t.string    :file
      
      t.timestamps
      
      # 
      # Publishing
      
      t.boolean :user_has_selected_thumbnail      # When true, we'll assume the thumbnail is high quality
      t.boolean :file_uploaded
      t.boolean :file_published
    end
  end
  
  def self.down
    drop_table :games
  end
end
