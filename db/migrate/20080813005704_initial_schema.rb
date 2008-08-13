class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :operations do |t|
      t.string :what
      t.integer :person_id, :default => nil
      t.integer :session_id, :default => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :operations
  end
end
