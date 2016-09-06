class AddCaptionsToShifts < ActiveRecord::Migration[5.0]
    def change
        add_column :shifts, :caption_en, :string
        add_column :shifts, :caption_ru, :string
    end
end
