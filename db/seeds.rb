# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin_user = User.create(name: "管理ユーザーA", email: "admin@a.com", password: "aaaaaa", admin: true)
user = User.create(name: "一般ユーザーB", email: "a@a.com", password: "aaaaaa", admin: false)

(1..30).each do |i|
  task = Task.create(title: "タイトル#{i}", content: "内容#{i}", deadline: "2020-01-#{i}", status: i % 3 + 1, priority: (i + 1) % 3 + 1, user: user)
end

task = Task.create(title: "管理A", content: "管理A", deadline: "2020-02-01", status: 1, priority: 1, user: admin_user)
task = Task.create(title: "管理B", content: "管理B", deadline: "2020-02-02", status: 2, priority: 2, user: admin_user)
task = Task.create(title: "管理C", content: "管理A", deadline: "2020-02-03", status: 3, priority: 3, user: admin_user)
