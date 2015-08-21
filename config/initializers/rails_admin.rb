RailsAdmin.config do |config|

  config.current_user_method(&:current_user)
  config.authorize_with :cancan

  # Options
  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  # Look firstly for #to_s as label
  config.label_methods = [:to_s].concat(config.label_methods)

  config.model 'Author' do
    include_all_fields
    field :biography, :froala
  end

  config.model 'Book' do
    include_all_fields
    field :full_description, :froala
  end

  config.model 'User' do
    exclude_fields :reset_password_sent_at, :remember_created_at
  end
end
