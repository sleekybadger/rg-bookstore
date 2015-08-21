class Ability

  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :read, :update, :destroy, to: :rud
    alias_action :update, :destroy, to: :ud

    if user
      if user.is_admin?
        can :access, :rails_admin
        can :dashboard
        can :manage, :all
      else
        can :rud, [BillingAddress, ShippingAddress], addressable_type: 'User', addressable_id: user.id
        can :create, BillingAddress unless user.billing_address.present? && user.billing_address.id
        can :create, ShippingAddress unless user.shipping_address.present? && user.shipping_address.id
        can :ud, User, id: user.id

        can :add_review_to_book, Book do |book|
          true unless user.is_left_review?(book)
        end
      end
    end

    can :read, Book
    can :read, Category
    can :read, Author
    can :read, User
  end

end
