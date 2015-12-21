object false

node(:id) do
  @bird._id.to_s
end
node(:name) do
  @bird.name
end
node(:family) do
  @bird.family
end
node(:added) do
  @bird.added
end
node(:visible) do
  @bird.visible
end
node(:continents) do
  @bird.continents.map{|c| c.name}
end