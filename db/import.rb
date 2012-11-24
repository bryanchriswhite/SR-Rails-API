headers = %w[name author forum_url created_at]
CSV.foreach "#{Rails.root}/db/mods.csv" do |row|
  Mod.create Hash[headers.zip(row)]
end
