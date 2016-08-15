class AddDustToChecks < ActiveRecord::Migration[5.0]
    def change
        add_column :checks, :dust, :integer, default: 0
    end
end
