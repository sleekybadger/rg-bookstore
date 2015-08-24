def stringify(hash = {})
  out ={}

  hash.each_pair do |key, value|
    out[key.to_s] = value.to_s
  end

  out
end