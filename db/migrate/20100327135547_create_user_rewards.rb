class CreateUserRewards < ActiveRecord::Migration
  def self.up
    create_table :user_rewards do |t|
      
      # Hidden Rewards - if the user chooses not to publish the reward to facebook, they show up as
      # mystery rewards on their public profile. For example, a user will have `num_bug_cookies` - 
      # `num_bug_cookies_hidden` bug cookies on their profile, and `num_bug_cookies_hidden` mystery
      # rewards
      
      t.integer   :num_bug_cookies_hidden,      :default => 0
      t.integer   :num_bug_cookies_visible,     :default => 0       # Number of bugs reported by user, little cookie icons on the user's profile
                                                                    # BETA - Every tester automatically gets one
      t.integer   :num_users_recruited_hidden,  :default => 0
      t.integer   :num_users_recruited_visible, :default => 0       # For every user you successfully recruit, you get a reward!
    end
    
    change_table :users do |t|
      t.references :user_reward
    end
  end

  def self.down
    drop_table :user_rewards
    remove_column :users, :user_reward_id
  end
end
