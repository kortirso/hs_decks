class ChangeStylesTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :styles, :name_en
    remove_column :styles, :name_ru
    add_column :styles, :name, :hstore, default: { en: '', ru: '' }, null: false
  end
end
