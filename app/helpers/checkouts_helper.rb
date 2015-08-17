module CheckoutsHelper

  def wizard_progress
    out = []

    wizard_steps.collect do |s|
      finished = past_step?(s)

      classes = 'step'
      classes += (s == step) ? ' current' : ''
      classes += finished ? ' finished' : ''

      out.push({
        name: s,
        title: s.to_s.capitalize,
        classes: classes,
      })
    end

    out
  end

end
