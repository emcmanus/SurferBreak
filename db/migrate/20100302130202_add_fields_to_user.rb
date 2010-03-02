class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.text :about
      t.string :photo # S3 Object ID
      t.string :name
      t.date :expiration
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :about, :photo, :name, :expiration
    end
  end
end
