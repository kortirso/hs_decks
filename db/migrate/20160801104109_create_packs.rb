class CreatePacks < ActiveRecord::Migration[5.0]
    def change
        create_table :packs do |t|
            t.integer :user_id
            t.integer :card_id
            t.integer :amount
            t.timestamps
        end
        add_index :packs, :user_id
        add_index :packs, :card_id
    end
end
