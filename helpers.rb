module Utils
  def data_path date
    "#{options.root}/public/data/#{date[0..3]}/#{date}.xml"
  end
end
