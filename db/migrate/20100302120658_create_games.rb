class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      
      t.float     :avg_rating,                :null => false,   :default => 0
      t.integer   :num_ratings,               :null => false,   :default => 0
      t.float     :ranked_value,              :null => false,   :default => 0
      t.boolean   :deleted,                   :null => false,   :default => false
      t.boolean   :received_dmca_takedown,    :null => false,   :default => false
      t.integer   :play_count,                :null => false,   :default => 0
      t.string    :platform,                  :null => false,   :default => "NES"
      t.text      :description
      t.string    :title
      
      # File attributes
      t.string    :file,                      :null => false
      
      t.timestamps
      
      # 
      # Publishing
      
      t.boolean :user_has_selected_thumbnail, :null => false,   :default => false      # When true, we'll assume the thumbnail is high quality
      t.boolean :file_uploaded,               :null => false,   :default => false
      t.boolean :file_processed,              :null => false,   :default => false
      t.boolean :file_published,              :null => false,   :default => false
    end
  end
  
  def self.down
    drop_table :games
  end
end
