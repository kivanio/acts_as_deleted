# ActsAsDeleted
module Acts #:nodoc:
  module As
    module Deleted
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
        base.send           :include, InstanceMethods
        base.before_validation_on_create  :undelete
      end

      module ClassMethods

        def acts_as_deleted
          self.named_scope :with_deleted, :conditions => {:deleted => true}
          self.named_scope :without_deleted, :conditions => {:deleted => false}
        end

      end

      module InstanceMethods

        # Set record as undeleted
        def undelete
          write_attribute('deleted', 0) if respond_to?(:deleted)
        end
        # set record as deleted
        
        def delete
          t = self.class.default_timezone == :utc ? Time.now.utc : Time.now
          write_attribute('deleted', 1) if respond_to?(:deleted)
          write_attribute('deleted_at', t) if respond_to?(:deleted_at)
          self.save(false)
        end
        
        # set record as deleted with user.
        # Compatible with restful-authentication
        def delete_with_user(user_id)
          t = self.class.default_timezone == :utc ? Time.now.utc : Time.now
          write_attribute('deleted_at', t) if respond_to?(:deleted_at)
          write_attribute('deleted', 1) if respond_to?(:deleted)
          write_attribute('deleted_id', user_id) if respond_to?(:deleted_id)
          self.save(false)
        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, Acts::As::Deleted) if defined?(ActiveRecord)