class CreateFacebookCaches < ActiveRecord::Migration
  def self.up
    
    create_table :facebook_caches do |t|
      t.timestamps
      t.datetime    :invalidates_at
      
      # The fields we care about
      
      t.string      :name
      t.string      :email
      t.string      :username
      t.text        :about_me
      t.string      :profile_url
      t.string      :sex
      t.string      :website
      
      t.text        :status_message
      t.datetime    :status_time
      
      t.string      :pic
      t.string      :pic_with_logo
      t.string      :pic_big
      t.string      :pic_big_with_logo
      t.string      :pic_small
      t.string      :pic_small_with_logo
      t.string      :pic_square
      t.string      :pic_square_with_logo
    end
    
    # User FK
    change_table :users do |t|
      t.references  :facebook_cache
    end
    
  end
  
  def self.down
    drop_table :facebook_caches
    remove_column :users, :facebook_cache_id
  end
end
