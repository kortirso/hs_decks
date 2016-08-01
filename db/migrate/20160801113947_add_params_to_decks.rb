class AddParamsToDecks < ActiveRecord::Migration[5.0]
    def change
        add_column :decks, :link, :string
        add_column :decks, :caption, :string
    end
end
