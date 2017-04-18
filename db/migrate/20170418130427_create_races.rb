class CreateRaces < ActiveRecord::Migration[5.0]
    def change
        create_table :races do |t|
            t.string :name_en
            t.string :name_ru
            t.timestamps
        end
        add_column :cards, :race_id, :integer
        add_index :cards, :race_id
    end
end
