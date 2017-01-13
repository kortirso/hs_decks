class CreateMulligans < ActiveRecord::Migration[5.0]
    def change
        create_table :mulligans do |t|
            t.integer :deck_id
            t.integer :player_id
            t.timestamps
        end
        add_index :mulligans, :deck_id
        add_index :mulligans, :player_id
    end
end
