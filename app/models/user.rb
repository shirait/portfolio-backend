class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :tasks, dependent: :restrict_with_exception
  has_many :comments, dependent: :restrict_with_exception

  enum :role, { normal: 0, admin: 1, viewer: 2 }, validate: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  has_many :tasks
end
