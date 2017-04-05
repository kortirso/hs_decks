class AddEnToDecks < ActiveRecord::Migration[5.0]
    def change
        add_column :decks, :name_en, :string
        add_column :decks, :caption_en, :text
    end
end
