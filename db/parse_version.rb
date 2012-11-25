Mod.all.each do |mod|
  match_data = mod.name.match(/\[(?<n>[\d|\w|\.]+)\]/)
  @version = ''
  unless match_data == nil
    @version = match_data[:n]
  end
  mod.minecraft_version = @version
  mod.save
end
