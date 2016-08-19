class CreateShifts < ActiveRecord::Migration[5.0]
    def change
        create_table :shifts do |t|
            t.integer :card_id, null: false
            t.integer :change_id, null: false
            t.integer :priority, null: false
            t.timestamps
        end
        add_index :shifts, :card_id
        add_index :shifts, :change_id
    end
end
