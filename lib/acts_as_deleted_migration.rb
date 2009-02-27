module Acts
  module DeletedMigration
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def deletestamps(include_deleted_by = false)
        column(:deleted, :boolean, :default => false)
        column(:deleted_at, :datetime)
        column(:deleted_by, :integer) if include_deleted_by
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, Acts::DeletedMigration)
ActiveRecord::ConnectionAdapters::Table.send(:include, Acts::DeletedMigration)