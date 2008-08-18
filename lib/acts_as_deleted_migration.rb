module Acts
  module As
    module DeletedMigration
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
        def deletestamps(include_deleted_id = false)
          column(:deleted, :boolean)
          column(:deleted_at, :datetime)
          column(:deleted_id, :integer) if include_deleted_id
        end
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, Acts::As::DeletedMigration)