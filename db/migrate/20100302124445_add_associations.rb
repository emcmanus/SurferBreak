class AddAssociations < ActiveRecord::Migration
  def self.up
    
    change_table :games do |t|
      t.references :user
      t.references :thumbnail
    end
    
    change_table :thumbnails do |t|
      t.references :game
    end
    
    change_table :ratings do |t|
      t.references :user
      t.references :game
    end
    
    change_table :feedbacks do |t|
      t.references :user
    end
    
  end

  def self.down
  end
end
