class ChangePlayerTable < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'hstore'
    remove_column :players, :name_en
    remove_column :players, :name_ru
    add_column :players, :name, :hstore, default: { 'en' => '', 'ru' => '' }, null: false
  end
end
