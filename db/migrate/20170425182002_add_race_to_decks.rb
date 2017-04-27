class AddRaceToDecks < ActiveRecord::Migration[5.0]
    def change
        add_column :decks, :race_id, :integer
        add_index :decks, :race_id
    end
end
