class AddRussianToCollections < ActiveRecord::Migration[5.0]
    def self.up
        rename_column :collections, :name, :name_en
        add_column :collections, :name_ru, :string
    end

    def self.down
        rename_column :collections, :name_en, :name
        remove_column :collections, :name_ru
    end
end
