ActiveRecord::Schema.define(:version => 0) do
  create_table :thingies, :force => true do |t|
    t.string :name
    
    t.boolean :deleted, :default => false
    t.datetime :deleted_at
    t.integer :deleted_by
  end
end