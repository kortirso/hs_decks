class CreateAbouts < ActiveRecord::Migration[5.0]
    def change
        create_table :abouts do |t|
            t.string :version, null: false
            t.string :label_en, null: false
            t.string :label_ru, null: false
            t.timestamps
        end
    end
end
