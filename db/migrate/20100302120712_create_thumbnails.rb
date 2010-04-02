class CreateThumbnails < ActiveRecord::Migration
  def self.up
    create_table :thumbnails do |t|
      
      t.string :path,     :null => false
      t.integer :width,   :null => false
      t.integer :height,  :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :thumbnails
  end
end
