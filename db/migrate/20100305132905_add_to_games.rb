class AddToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :is_uploaded,          :boolean, :default => false,  :nil => false
    add_column :games, :show_in_publish_form, :boolean, :default => true,   :nil => false
    
    add_index :games, :storage_object_id
  end

  def self.down
    remove_column :games, :is_uploaded
    remove_column :games, :show_in_publish_form
    
    remove_index :games, :storage_object_id
  end
end
