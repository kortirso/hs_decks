class AddRenoToDecks < ActiveRecord::Migration[5.0]
    def change
        add_column :decks, :reno_type, :boolean, default: false
    end
end
