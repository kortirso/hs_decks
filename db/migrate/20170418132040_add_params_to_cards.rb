class AddParamsToCards < ActiveRecord::Migration[5.0]
    def change
        add_column :cards, :attack, :integer
        add_column :cards, :health, :integer
        add_column :cards, :mechanics, :string, array: true
        add_column :cards, :race_name, :string
        remove_column :cards, :image_en
        remove_column :cards, :image_ru
    end
end
