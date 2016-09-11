class CreatePlayers < ActiveRecord::Migration[5.0]
    def change
        create_table :players do |t|
            t.string :name_en
            t.string :name_ru
            t.timestamps
        end

        add_column :cards, :player_id, :integer
        add_index :cards, :player_id
        add_column :decks, :player_id, :integer
        add_index :decks, :player_id
    end
end
