# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
(1..30).each do |i|
  task = Task.create(title: "タイトル#{i}", content: "内容#{i}", deadline: "2020-01-#{i}", status: i % 3 + 1, priority: (i + 1) % 3 + 1)
end
