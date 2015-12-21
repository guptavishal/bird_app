collection @birds, :object_root => false
attributes :name, :family, :added, :visible

node(:id) do |bird|
  bird._id.to_s
end
node(:continents) do |bird|
  bird.continents.map{|c| c.name}
end