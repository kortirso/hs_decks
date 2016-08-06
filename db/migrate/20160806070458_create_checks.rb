class CreateChecks < ActiveRecord::Migration[5.0]
    def change
        create_table :checks do |t|
            t.integer :user_id, null: false
            t.integer :deck_id, null: false
            t.integer :success, null: false
            t.timestamps
        end
        add_index :checks, :user_id
        add_index :checks, :deck_id
    end
end
