class Reward < ActiveRecord::Base
  
  has_one :user
  
  def count_total_for(field)
    self["num_#{field}_visible"] + self["num_#{field}_hidden"]
  end
  
  def count_rewards
    self.count_total_for("bug_cookies") + self.count_total_for("users_recruited")
  end
  
  def count_hidden_rewards
    self.num_bug_cookies_hidden + self.num_users_recruited_hidden
  end
end
