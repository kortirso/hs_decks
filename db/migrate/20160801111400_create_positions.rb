class CreatePositions < ActiveRecord::Migration[5.0]
    def change
        create_table :positions do |t|
            t.integer :deck_id
            t.integer :card_id
            t.integer :amount
            t.timestamps
        end
        add_index :positions, :deck_id
        add_index :positions, :card_id
    end
end
