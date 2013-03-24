require 'active_record'

module SpaceCadet

  class UuidCore < ActiveRecord::Migration

    def self.up
      create_table :uuids do |t|
        t.integer :source_id
        t.string :source_name
        t.integer :space_id
        t.string :uuid
      end

      add_index :uuids, :space_id, unique: true
      add_index :uuids, [:source_name, :source_id], unique: true
    end

    def self.down
      drop_table :uuids
    end

  end # UuidCore

  class Uuid < ActiveRecord::Base
  end # Uuid

end # SpaceCadet

