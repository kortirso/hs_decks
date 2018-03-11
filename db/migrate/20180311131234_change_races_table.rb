class ChangeRacesTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :races, :name_en
    remove_column :races, :name_ru
    add_column :races, :name, :hstore, default: { en: '', ru: '' }, null: false
  end
end
