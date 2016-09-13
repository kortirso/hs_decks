class AddCaptionToPositions < ActiveRecord::Migration[5.0]
    def change
        add_column :positions, :caption, :string, default: nil
    end
end
