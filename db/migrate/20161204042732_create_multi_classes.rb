class CreateMultiClasses < ActiveRecord::Migration[5.0]
    def change
        create_table :multi_classes do |t|
            t.string :name_en
            t.string :name_ru
            t.timestamps
        end
        add_column :players, :multi_class_id, :integer
        add_index :players, :multi_class_id
    end
end
