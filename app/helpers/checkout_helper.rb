module CheckoutHelper

  def wizard_progress
    out = []

    wizard_steps.map do |s|
      finished = past_step?(s)

      classes = 'step'
      classes += (s == step) ? ' active' : ''
      classes += finished ? ' finished' : ''

      out.push({
        name: s,
        classes: classes,
      })
    end

    out
  end

  def months_for_select
    (1..12).each.collect { |i| [Date::MONTHNAMES[i], i]  }
  end

end
