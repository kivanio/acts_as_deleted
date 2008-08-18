# Include hook code here
require 'acts_as_deleted'

ActiveRecord::Base.send :include, Acts::As::Deleted