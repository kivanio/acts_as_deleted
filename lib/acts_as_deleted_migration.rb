module Acts
  module As
    module DeletedMigration
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
        def deletestamps(include_deleted_by = false)
          column(:deleted, :boolean)
          column(:deleter_id, :integer) if include_deleted_by
        end
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, Acts::As::DeletedMigration)