require "csv"
class Array
  def squash!
    self.each do |e|
      e.strip!
      e.gsub! /'/,""
    end
  end
end
headers = %w[name description]
lines = CSV.read("#{Dir.pwd}/db/data.csv")
lines.each do |line|
  category_hash = Hash[headers.zip(line.squash!)]
  Category.create! category_hash
end


