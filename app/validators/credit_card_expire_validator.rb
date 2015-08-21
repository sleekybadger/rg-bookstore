class CreditCardExpireValidator < ActiveModel::Validator
  def validate(record)
    unless record.expiration_year.present? && record.expiration_year > 0
      return
    end

    unless record.expiration_month.present? && record.expiration_month > 0 && record.expiration_month < 12
      return
    end

    now = Date.today
    expire = Date.new(record.expiration_year, record.expiration_month, now.day)

    if expire < now
      record.errors.add(:expiration_date, 'can not be in the past')
    end
  end
end