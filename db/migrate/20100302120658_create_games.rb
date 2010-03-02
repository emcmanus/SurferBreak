class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.float :avg_rating
      t.integer :num_ratings
      t.float :ranked_value
      t.boolean :deleted
      t.integer :play_count
      t.boolean :removed
      t.string :platform
      t.string :file
      t.text :description
      t.string :title
      t.boolean :is_adult

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
