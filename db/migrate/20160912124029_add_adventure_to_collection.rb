class AddAdventureToCollection < ActiveRecord::Migration[5.0]
    def change
        add_column :collections, :adventure, :boolean, default: false
        add_column :cards, :craft, :boolean, default: true
    end
end
