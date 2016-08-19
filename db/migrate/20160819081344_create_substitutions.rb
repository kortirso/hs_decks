class CreateSubstitutions < ActiveRecord::Migration[5.0]
    def change
        create_table :substitutions do |t|
            t.integer :check_id, null: false
            t.timestamps
        end
        add_index :substitutions, :check_id
    end
end
