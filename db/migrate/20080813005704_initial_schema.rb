class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :name
      t.integer :session
    end

  end

  def self.down
    drop_table :people
  end
end
