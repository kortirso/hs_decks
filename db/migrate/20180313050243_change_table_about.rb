class ChangeTableAbout < ActiveRecord::Migration[5.1]
  def change
    remove_column :abouts, :label_en
    remove_column :abouts, :label_ru
    add_column :abouts, :name, :hstore, default: { en: '', ru: '' }, null: false
  end
end
