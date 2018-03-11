class ChangeCollectionsTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :collections, :name_en
    remove_column :collections, :name_ru
    add_column :collections, :name, :hstore, default: { en: '', ru: '' }, null: false
  end
end
