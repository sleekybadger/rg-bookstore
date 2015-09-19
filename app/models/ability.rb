class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :read, :update, :destroy, to: :rud

    if user
      if user.is_admin?
        can :access, :rails_admin
        can :dashboard
        can :manage, :all
      else
        can %i(create read), Wish
        can :destroy, Wish, user_id: user.id
        can :rud, [Shopper::BillingAddress, Shopper::ShippingAddress], addressable_type: 'User', addressable_id: user.id
        can :create, Shopper::BillingAddress unless user.billing_address.present? && user.billing_address.id
        can :create, Shopper::ShippingAddress unless user.shipping_address.present? && user.shipping_address.id
        can :rud, User, id: user.id
        can :update_info, User, id: user.id
        can :update_password, User, id: user.id

        can :add_review_to_book, Book do |book|
          true unless user.is_left_review?(book)
        end
      end
    end

    can :read, Book
    can :read, Category
    can :read, Author
  end
end
