module NokogiriHelper

  def doc(path)
    File.open(path) {|f| Nokogiri::XML(f) }
  end

  def str(path)
    File.open(path) {|f| f.read }
  end

end