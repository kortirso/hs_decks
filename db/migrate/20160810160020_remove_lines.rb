class RemoveLines < ActiveRecord::Migration[5.0]
    def change
        drop_table :lines
        drop_table :positions
        drop_table :packs

        create_table :positions do |t|
            t.integer :amount, null: false
            t.integer :positionable_id
            t.string  :positionable_type
            t.integer :card_id

            t.timestamps null: false
        end

        add_index :positions, [:positionable_id, :positionable_type]
        add_index :positions, :card_id
    end
end
