# frozen_string_literal: true

User.find_or_create_by!(email: "normal@example.com") do |user|
  user.password = "faipheiz4ieY"
  user.password_confirmation = "faipheiz4ieY"
  user.name = "Normal User"
  user.role = 0
end

User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "chif9os3Xara"
  user.password_confirmation = "chif9os3Xara"
  user.name = "Admin User"
  user.role = 1
end

User.find_or_create_by!(email: "viewer@example.com") do |user|
  user.password = "vahquee9OChu"
  user.password_confirmation = "vahquee9OChu"
  user.name = "Viewer User"
  user.role = 2
end
