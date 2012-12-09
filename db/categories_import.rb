require "csv"
headers = %w[name description]
lines = CSV.read("#{Dir.pwd}/db/data.csv")
lines.each do |line|
  category_hash = Hash[headers.zip(line)]
  Category.create! category_hash
end


