inserts = []
t = Time.current

# Collections creating
Collection.all.destroy_all
%w(Basic Classic Promo Reward Naxxramas Goblins\ vs\ Gnomes Blackrock\ Mountain The\ Grand\ Tournament The\ League\ of\ Explorers Whispers\ of\ the\ Old\ Gods).each do |c|
    inserts.push "('#{c}', '#{t}', '#{t}')"
end
Collection.connection.execute "INSERT INTO collections (name, created_at, updated_at) VALUES #{inserts.join(", ")}"