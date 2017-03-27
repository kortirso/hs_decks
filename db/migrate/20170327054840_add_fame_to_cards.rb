class AddFameToCards < ActiveRecord::Migration[5.0]
    def change
        add_column :cards, :hall_of_fame, :boolean, default: false
    end
end
