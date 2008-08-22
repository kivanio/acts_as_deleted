# ActsAsDeleted
module Acts #:nodoc:
  module Deleted

    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.before_validation_on_create  :undelete
    end

    module ClassMethods

      # You can pass name of scope that you want to use
      def acts_as_deleted(deleted=:with_deleted,not_deleted=:without_deleted)

        # class << self  
        #   alias_method :original_with_deleted, :with_deleted if method_defined?(:with_deleted)
        #   alias_method :original_without_deleted, :without_deleted if method_defined?(:without_deleted)
        # end

        named_scope deleted, :conditions => {:deleted => true}
        named_scope not_deleted, :conditions => {:deleted => false}

        include InstanceMethods unless self.included_modules.include?(InstanceMethods)
      end

    end

    module InstanceMethods

      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
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

ActiveRecord::Base.send(:include, Acts::Deleted) if defined?(ActiveRecord)