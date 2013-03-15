require "rubygems"
require "active_record"
require "sqlite3"

ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => ":memory:",
})

ActiveRecord::Schema.define do
  self.verbose = false

  create_table "accounts", :force => true do |t|
    t.string "name", :null => false
    t.integer "user_count", :null => false, :default => 0
  end

  create_table "users", :force => true do |t|
    t.string "email", :null => false
    t.integer "account_id", :null => false
  end
end

class Account < ActiveRecord::Base
end

class User < ActiveRecord::Base
  belongs_to :account
end

class UserMailer
  def self.deliver(user)
    raise "Whoa, I'm slow"
  end
end
