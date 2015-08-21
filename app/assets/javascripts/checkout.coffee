checkout =
  init: ->
    @_form = $('.shipping-address-form')
    @_checkbox = $('#same_as_billing')

    @toggle_form(@_checkbox.prop('checked'))
    @add_handlers()

  add_handlers: ->
    @_checkbox.on 'click', (event) =>
      @toggle_form(event.target.checked)

  toggle_form: (value) ->
    if value
      @_form.hide()
    else
      @_form.show()

checkout.init()