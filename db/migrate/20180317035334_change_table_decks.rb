class ChangeTableDecks < ActiveRecord::Migration[5.1]
  def change
    remove_column :decks, :name
    remove_column :decks, :name_en
    add_column :decks, :name, :hstore, default: { en: '', ru: '' }, null: false
  end
end
