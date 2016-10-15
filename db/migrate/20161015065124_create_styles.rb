class CreateStyles < ActiveRecord::Migration[5.0]
    def change
        create_table :styles do |t|
            t.string :name_en
            t.string :name_ru
            t.timestamps
        end
        add_column :decks, :style_id, :integer
        add_index :decks, :style_id
    end
end
