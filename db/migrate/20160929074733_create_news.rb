class CreateNews < ActiveRecord::Migration[5.0]
    def change
        create_table :news do |t|
            t.string :url_label, null: false
            t.string :label, null: false
            t.string :caption, null: false
            t.string :image, null: false, default: 'news-default-image.jpg'
            t.string :link
            t.timestamps
        end
        add_column :users, :get_news, :boolean, default: false
    end
end
