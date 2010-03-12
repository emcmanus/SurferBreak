class AddToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :is_published, :boolean, :default => false, :nil => false
    add_column :games, :is_uploaded, :boolean, :default => false, :nil => false
    add_column :games, :generated_thumbs, :boolean, :default => false, :nil => false
    add_index :games, :storage_object_id
  end

  def self.down
    remove_column :games, :is_published
    remove_column :games, :is_uploaded
    remove_column :games, :generated_thumbs
    remove_index :games, :storage_object_id
  end
end
