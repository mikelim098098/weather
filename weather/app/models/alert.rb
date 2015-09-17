class Alert < ActiveRecord::Base
	belongs_to :user

	def self.hello
		puts self.all
	end
end
