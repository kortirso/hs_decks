class AddPriceToDecks < ActiveRecord::Migration[5.0]
    def change
        add_column :decks, :price, :integer, default: 0
    end
end
