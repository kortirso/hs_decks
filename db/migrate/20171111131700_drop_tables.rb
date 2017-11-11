class DropTables < ActiveRecord::Migration[5.1]
    def change
        drop_table :oauth_access_grants
        drop_table :oauth_access_tokens
        drop_table :oauth_applications
    end
end
