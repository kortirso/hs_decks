class AddIndexToCards < ActiveRecord::Migration[5.0]
    def change
        add_column :cards, :multi_class_id, :integer, default: nil
        add_index :cards, :multi_class_id
    end
end
