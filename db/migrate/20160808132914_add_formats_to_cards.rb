class AddFormatsToCards < ActiveRecord::Migration[5.0]
    def change
        add_column :cards, :formats, :string, default: 'standard', null: false
    end
end
