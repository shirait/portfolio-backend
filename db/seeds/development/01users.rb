# frozen_string_literal: true

User.find_or_create_by!(email: "normal@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.name = "Normal User"
  user.role = 0
end

User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.name = "Admin User"
  user.role = 1
end

(1..10).each do |i|
  User.find_or_create_by!(email: "normal#{i}@example.com") do |user|
    user.password = "password"
    user.password_confirmation = "password"
    user.name = "Normal User #{i}"
    user.role = 0
  end
end

User.find_or_create_by!(email: "viewer@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.name = "Viewer User"
  user.role = 2
end
