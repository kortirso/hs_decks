class AddMusthaveToPositions < ActiveRecord::Migration[5.0]
    def change
        add_column :positions, :must_have, :boolean, default: false
    end
end
