Mod.all.each do |mod|
	mod.name.sub!(/\[([\d|\w|\.|\/|\\|\-| ]+)\] ?/, '')
	puts mod.name
  mod.save!
end
