module ApplicationHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def cart_items
    @current_order.order_items
  end

  def glyph_icon(*names)
    content_tag :i, nil, class: names.map{|name| "glyphicon glyphicon-#{name.to_s.gsub('_','-')}" }
  end

  def shopping_cart_link
    size = cart_items.empty? ? t('cart.emprty_short') : " (#{cart_items.size} - #{@current_order.items_total_price}#{t('currancy')})"

    link_to glyph_icon(:shopping_cart) + size, cart_path
  end

  def current_p?(*paths)
    paths.include?(request.path)
  end

  def beauty_price(price)
    '%.2f' % price
  end

  def title(text)
    content_for :title, text
  end

end
