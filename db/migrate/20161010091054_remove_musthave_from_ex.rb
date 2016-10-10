class RemoveMusthaveFromEx < ActiveRecord::Migration[5.0]
    def change
        remove_column :exchanges, :must_have
    end
end
