mods = Mod.where("minecraft_version like '%1.4.4%'")
CSV.open("#{Rails.root}/db/output.csv", 'wb') do |csv|
  mods.each do |mod|
    csv << [mod.name, mod.author, mod.minecraft_version, mod.forum_url, mod.created_at]
  end
end
