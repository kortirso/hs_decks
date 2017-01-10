class AddPlayableToPlayers < ActiveRecord::Migration[5.0]
    def change
        add_column :players, :playable, :boolean, default: true
    end
end
