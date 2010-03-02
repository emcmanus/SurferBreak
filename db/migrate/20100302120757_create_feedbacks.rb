class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.string :email
      t.text :body
      t.string :submission_url

      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
