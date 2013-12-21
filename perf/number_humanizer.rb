module NumberHumanizer

  def self.humanize(number)
    # TODO: prevent "10.0k"; if 10.0 == 10.to_f, just use 10
    case number
    when 1_000..999_000
      "#{(number / 1_000.0).round(1)}k"
    when 1_000_000..999_000_000
      "#{(number / 1_000_000.0).round(1)}m"
    when 1_000_000_000..999_000_000_000
      "#{(number / 1_000_000_000.0).round(1)}b"
    else
      number.to_s
    end
  end

end
