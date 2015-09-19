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

  def glyph_icon(*names)
    content_tag :i, nil, class: names.map{|name| "glyphicon glyphicon-#{name.to_s.gsub('_','-')}" }
  end

  def shopping_cart_link
    text =
      if @current_order.order_items.empty?
        t('cart.short_empty')
      else
        " (#{@current_order.order_items.size} - #{beauty_price(@current_order.items_price)}#{t('currancy')})"
      end

    link_to glyph_icon(:shopping_cart) + text, shopper_path
  end

  def current_p?(*paths)
    paths.include?(request.path)
  end

  def title(text)
    content_for :title, text
  end
end
