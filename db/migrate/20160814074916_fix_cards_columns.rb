class FixCardsColumns < ActiveRecord::Migration[5.0]
    def self.up
        rename_column :cards, :name, :name_en
        rename_column :cards, :image, :image_en
    end

    def self.down
        rename_column :cards, :name_en, :name
        rename_column :cards, :image_en, :image
    end
end
