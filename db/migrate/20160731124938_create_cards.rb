class CreateCards < ActiveRecord::Migration[5.0]
    def change
        create_table :cards do |t|
            t.string :cardId, null: false
            t.string :name, null: false
            t.string :type, null: false
            t.integer :cost
            t.string :playerClass
            t.string :rarity, null: false
            t.integer :collection_id, null: false
            t.timestamps
        end
        add_index :cards, :collection_id
    end
end
