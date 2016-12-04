class AddMultisToCards < ActiveRecord::Migration[5.0]
    def change
        add_column :cards, :multiClassGroup, :string, default: nil
    end
end
