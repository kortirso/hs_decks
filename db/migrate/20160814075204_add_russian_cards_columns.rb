class AddRussianCardsColumns < ActiveRecord::Migration[5.0]
    def change
        add_column :cards, :name_ru, :string
        add_column :cards, :image_ru, :string
    end
end
