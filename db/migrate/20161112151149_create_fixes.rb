class CreateFixes < ActiveRecord::Migration[5.0]
    def change
        create_table :fixes do |t|
            t.string :body_en, null: false
            t.string :body_ru, null: false
            t.integer :about_id
            t.timestamps
        end
        add_index :fixes, :about_id
    end
end
