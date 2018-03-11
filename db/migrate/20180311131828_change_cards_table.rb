class ChangeCardsTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :cards, :name_en
    remove_column :cards, :name_ru
    remove_column :cards, :hall_of_fame
    add_column :cards, :name, :hstore, default: { en: '', ru: '' }, null: false
    add_column :cards, :dbfid, :string, null: false, default: ''
  end
end
