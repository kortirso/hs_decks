class ModifyDecks < ActiveRecord::Migration[5.0]
    def change
        change_column :decks, :caption, :text
        add_column :decks, :author, :string
    end
end
