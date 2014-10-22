class DataTable

  def self.default_page_size
    10
  end

  def self.default_page_block_size
    10
  end

  def initialize
    yield self if block_given?

    initialize_static_properties
    calculate_attribute_values
  end
  
  attr_accessor :total, :page_size, :page_block_size, :columns, :data, :page_index
  attr_reader :pages, :current_page_block, :page_size

  def render(options = {})
    builder = Nokogiri::HTML::Builder.new do |doc|
      props = {}
      props[:id] = options[:id] ||= "dt_#{10.times.map { Random.rand(10) }.join}"
      props[:name] = options[:name] ||= props[:id]
      props[:class] = options[:class] ||= 'table table-striped'
      doc.div {
        doc.table(props) {
          doc.thead {
            doc.tr {
              @columns.each do |column|
                doc.td column.title
              end
            }
          }

          props.clear
          doc.tbody {
            @data.each do |row|
              doc.tr {
                @columns.each do |column|
                  props[:width] = column.width if column.width > 0
                  ui = column.ui
                  binding = /%{[\d\w]+}/.match(ui[:value])
                  value = (binding) ? ui[:value].to_s.sub(/%{[\d\w]+}/, row.instance_eval(binding.to_s.sub('%{', '').sub('}', '')).to_s) : ui[:value]
                  doc.td(props) {
                    case ui[:type].to_s
                      when 'text' then doc.span value
                      when 'link' then doc.a(:href => value.html_safe, :class => ui[:class]) { doc.span ui[:label] }
                    end
                  }
                end
              }
            end
          }
        }
        pagination_layer(doc, options[:id]) unless options[:hide_pagination] == true
      }
    end    
    
    builder.to_html.html_safe
  end
  
  def has_next_page?
    @page_index < @pages
  end
  
  def has_previous_page?
    @page_index > 1
  end
  
  def has_page_index?(index)
    ((index > 0) && (@pages >= index))
  end
  
  def next_page
    return (@page_index + 1) if has_next_page?
    @page_index
  end
  
  def previous_page
    return (@page_index - 1) if has_previous_page?
    @page_index
  end
  
  def has_previous_pagination_block?
    block = @current_page_block
    (block.begin > @page_size)
  end
  
  def has_next_pagination_block?
    block = @current_page_block
    (block.end < @pages)
  end
  
  def previous_block_page
    return (@page_index - @page_size) if has_previous_pagination_block?
    @page_index
  end
  
  def next_block_page
    if has_next_pagination_block?
      page = @page_index + @page_size
      while(!has_page_index? page) do
        page -= 1
      end
      
      return page
    end
    
    @page_index
  end

  def calculate_attribute_values
    @pages = @total / @page_size
    @pages = ((@total % @page_size == 0) ? @pages : (@pages + 1))

    @page_index ||= 1
    @page_index = @pages if @page_index > @pages
    @page_index = 1 if @page_index <= 0

    @current_page_block = set_current_page_block
  end
  
  private
  def set_current_page_block
    min = (@page_index / @page_size)
    if (@page_index % @page_size) > 0
      min = (min == 0) ? 1 : (min * @page_size + 1)
    else
      min = min * @page_size - (@page_size - 1)
    end
    max = (min + @page_size - 1)
    max = (max - (max - @pages)) if max > @pages
    max = 1 if max < 1

    min..max
  end

  def initialize_static_properties
    @page_size ||= DataTable.default_page_size
    @page_block_size ||= DataTable.default_page_block_size
    @columns ||= []
    @data ||= []
    @total ||= 0
    @pages = 0
  end

  def pagination_layer(doc, table_id)
    return if self.pages == 0

    form_id = "form_#{table_id}"
    doc.form(:method => 'post', :action => '', :id => form_id) {
      doc.input(:type => 'hidden', :value => @page_index, :id => "#{table_id}-index", :name => "#{table_id}-index")
      doc.input(:type => 'hidden', :name => 'authenticity_token', :value => 'd92a4322cbbf20c4a1775cfe0e1c8753')
      doc.div(:class => 'pagination') {
        doc.ul {
          doc.li(:class => (self.has_previous_pagination_block? ? '' : 'disabled')) {
            doc.a(:href => (self.has_previous_pagination_block? ? "javascript: goToPage(#{self.previous_block_page})" : 'javascript: void(0)')) {
              doc.span '<<'
            }
          }
          doc.li(:class => (self.has_previous_page? ? '' : 'disabled')) {
            doc.a(:href => (self.has_previous_page? ? "javascript: goToPage(#{self.previous_page})" : 'javascript: void(0)')) {
              doc.span '<'
            }
          }

          self.current_page_block.each do |page|
            doc.li(:class => (self.page_index == page ? 'disabled' : '')) {
              doc.a(:href => (self.page_index == page ? 'javascript: void(0)' : "javascript: goToPage(#{page})")) {
                doc.span page
              }
            }
          end

          doc.li(:class => (self.has_next_page? ? '' : 'disabled')) {
            doc.a(:href => (self.has_next_page? ? "javascript: goToPage(#{self.next_page})" : 'javascript: void(0)')) {
              doc.span '>'
            }
          }
          doc.li(:class => (self.has_next_pagination_block? ? '' : 'disabled')) {
            doc.a(:href => (self.has_next_pagination_block? ? "javascript: goToPage(#{self.next_block_page})" : 'javascript: void(0)')) {
              doc.span '>>'
            }
          }
        }
      }
    }

    doc.script <<-eos
      function goToPage(index) {
        $('##{table_id}-index').val(index);
        $('##{form_id}').submit();
      }
    eos
  end
  
end