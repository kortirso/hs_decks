class CreateExchanges < ActiveRecord::Migration[5.0]
    def change
        create_table :exchanges do |t|
            t.integer :position_id
            t.integer :card_id
            t.boolean :must_have
            t.integer :priority
            t.integer :max_amount
            t.timestamps
        end
        add_index :exchanges, :position_id
        add_index :exchanges, :card_id
    end
end
