headers = %w[name author created_at forum_url]
CSV.foreach "#{Rails.root}/db/mods.csv" do |row|
  Mod.create Hash[headers.zip(row)]
end
