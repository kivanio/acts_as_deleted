# ActsAsDeleted
module Acts #:nodoc:
  module Deleted

    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
    end

    module ClassMethods
      # You can pass name of scope that you want to use
      def acts_as_deleted(deleted = :only_deleted, not_deleted = :without_deleted)
        named_scope deleted, :conditions => { :deleted => true }
        named_scope not_deleted, :conditions => { :deleted => false }
        
        define_callbacks :before_delete, :after_delete, :before_undelete, :after_undelete
        
        include InstanceMethods unless self.included_modules.include?(InstanceMethods)
      end
    end

    module InstanceMethods
      # Set record as undeleted
      def undelete
        callback(:before_undelete)
        write_attribute('deleted', false) if respond_to?(:deleted)
        write_attribute('deleted_at', nil) if respond_to?(:deleted_at)
        self.save(false)
        callback(:after_undelete)
      end
      
      # Set record as deleted
      def delete
        callback(:before_delete)
        delete_without_callbacks
        callback(:after_delete)
      end

      # Set record as deleted with user.
      # Compatible with restful-authentication
      def delete_with_user(user_id)
        callback(:before_delete)
        write_attribute('deleted_by', user_id) if respond_to?(:deleted_by)
        delete_without_callbacks
        callback(:after_delete)
      end

    protected
      def delete_without_callbacks
        t = self.class.default_timezone == :utc ? Time.now.utc : Time.now
        write_attribute('deleted', true) if respond_to?(:deleted)
        write_attribute('deleted_at', t) if respond_to?(:deleted_at)
        self.save(false)
      end
    end
  end
end

ActiveRecord::Base.send(:include, Acts::Deleted) if defined?(ActiveRecord)