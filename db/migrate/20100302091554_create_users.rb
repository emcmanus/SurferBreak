class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.timestamps
      
      t.string    :username                                           # optional, you can use email instead, or both
      t.string    :email                                              # optional, you can use username instead, or both
      t.string    :crypted_password                                   # optional, see below
      t.string    :password_salt                                      # optional, but highly recommended
      t.string    :persistence_token                                  # required
      t.string    :single_access_token                                # optional, see Authlogic::Session::Params
      t.string    :perishable_token                                   # optional, see Authlogic::Session::Perishability
      
      # Magic columns - automatically maintained by Authlogic if present
      
      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip
    end
    
    add_index :users, :username
    add_index :users, :persistence_token
    add_index :users, :last_request_at    # if we do "last active users"
  end

  def self.down
    drop_table :users
  end
end
