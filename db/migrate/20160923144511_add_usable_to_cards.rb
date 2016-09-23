class AddUsableToCards < ActiveRecord::Migration[5.0]
    def change
        add_column :cards, :usable, :integer, default: 0
    end
end
