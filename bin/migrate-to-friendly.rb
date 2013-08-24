User.find_each do |u|
  u.slug = nil
  u.save
end

Character.find_each do |c|
  c.slug = nil
  c.save
end
