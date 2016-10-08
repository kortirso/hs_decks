class AddTableLines < ActiveRecord::Migration[5.0]
    def change
        create_table :lines do |t|
            t.integer :deck_id, null: false
            t.integer :card_id, null: false
            t.integer :max_amount, null: false
            t.integer :priority, null: false
            t.integer :min_mana
            t.integer :max_mana
            t.timestamps
        end

        add_index :lines, :deck_id
        add_index :lines, :card_id
    end
end
