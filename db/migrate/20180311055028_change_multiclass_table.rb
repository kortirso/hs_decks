class ChangeMulticlassTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :multi_classes, :name_en
    remove_column :multi_classes, :name_ru
    add_column :multi_classes, :name, :hstore, default: { en: '', ru: '' }, null: false
  end
end
