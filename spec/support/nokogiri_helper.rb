module NokogiriHelper

  def doc(path)
    File.open(path) {|f| Nokogiri::XML(f) }
  end

end