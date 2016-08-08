class AddFormatToTables < ActiveRecord::Migration[5.0]
    def change
        add_column :collections, :formats, :string, default: 'standard', null: false
        add_column :decks, :formats, :string, default: 'standard', null: false
    end
end
