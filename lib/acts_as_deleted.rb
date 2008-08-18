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

      end
    end
  end
end

ActiveRecord::Base.send(:include, Acts::As::Deleted) if defined?(ActiveRecord)