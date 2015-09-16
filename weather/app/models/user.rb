class User < ActiveRecord::Base
  has_secure_password

  def self.testing
  	console.log('hi');
  end
end
