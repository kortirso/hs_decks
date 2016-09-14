class AddPowerToDecks < ActiveRecord::Migration[5.0]
    def change
        add_column :decks, :power, :integer, default: 1
    end
end
