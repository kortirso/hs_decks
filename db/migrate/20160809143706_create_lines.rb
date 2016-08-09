class CreateLines < ActiveRecord::Migration[5.0]
    def change
        create_table :lines do |t|
            t.integer :check_id
            t.integer :card_id
            t.string :success, null: false
            t.timestamps
        end

        add_index :lines, :card_id
        add_index :lines, :check_id
    end
end
