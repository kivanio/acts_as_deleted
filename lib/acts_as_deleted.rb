# ActsAsDeleted
module Acts #:nodoc:
  module As
    module Deleted
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_deleted
          self.named_scope :with_deleted, :conditions => {:deleted => true}
          self.named_scope :without_deleted, :conditions => {:deleted => false}

          self.before_validation_on_create do |model|
            model.deleted = 0 if model.respond_to?(:deleted)
          end
        end

      end

      module InstanceMethods
        def delete
          self.toggle(:deleted)
        end
        
        def delete_with_user(user_id)
          self.deleted = 1
          self.deleter_id = user_id if self.respond_to?(:deleter_id)
          self.save(false)
        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, Acts::As::Deleted) if defined?(ActiveRecord)