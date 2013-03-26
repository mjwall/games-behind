class Daily

  def get_xml date_str
    unless /\d{8}/.match date_str
      raise RuntimeError.new "Not an 8 digit date"
    end
    date_str
  end
end
