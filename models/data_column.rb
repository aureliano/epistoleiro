class DataColumn

  def initialize(options)
    @title = options[:title]
    @ui = options[:ui]
    @width = options[:width].to_i
  end

  attr_reader :title, :ui, :width

end