# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?
    send("#{user.role}_abilities", user)
  end

  private
  def admin_abilities(user)
    can :manage, :all
  end

  def normal_abilities(user)
    can :manage, Task
  end

  def viewer_abilities(user)
    can :read, Task
  end
end
