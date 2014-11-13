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
    return '' if @data.empty?
    
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
                  
                  doc.td(props) {
                    binding = /%{.+}/.match(ui[:onclick])
                    onclick = (binding) ? ui[:onclick].to_s.sub(/%{.+}/, row.instance_eval(binding.to_s.sub('%{', '').sub('}', '')).to_s) : ui[:onclick]

                    case ui[:type].to_s
                      when 'text' then doc.span _bind(row, ui[:value])
                      when 'link' then doc.a(:href => _bind(row, ui[:value]).html_safe, :class => ui[:class]) { doc.span _bind(row, ui[:label]) }
                      when 'input' then doc.input(:type => ui[:input_type], :value => _bind(row, ui[:value]), :class => ui[:class], :onclick => _bind(row, ui[:onclick]))
                    end
                  }
                end
              }
            end
          }
        }
        pagination_layer(doc, options[:id], options[:csrf_token]) if options[:hide_pagination] != true
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

  def pagination_layer(doc, table_id, csrf_token)
    return if self.pages == 0

    doc.input(:type => 'hidden', :value => @page_index, :id => "#{table_id}-index", :name => "#{table_id}-index")
    doc.input(:type => 'hidden', :name => 'authenticity_token', :value => csrf_token)
    doc.span I18n.translate('data_table_pagination').sub('%{page}', self.page_index.to_s).sub('%{pages}', self.pages.to_s).sub('%{total}', self.total.to_s)

    return if self.pages == 1

    doc.div(:class => 'pagination') {
      doc.ul {
        doc.li(:class => (self.has_previous_pagination_block? ? '' : 'disabled')) {
          doc.a(:id => "#{table_id}-block-previous", :onclick => ((self.has_previous_pagination_block?) ? "goToPage(this.id, #{self.previous_block_page})" : 'void(0)'), :href => 'javascript: void(0)') {
            doc.span '<<'
          }
        }
        doc.li(:class => (self.has_previous_page? ? '' : 'disabled')) {
          doc.a(:id => "#{table_id}-page-previous", :onclick => ((self.has_previous_page?) ? "goToPage(this.id, #{self.previous_page})" : 'void(0)'), :href => 'javascript: void(0)') {
            doc.span '<'
          }
        }

        self.current_page_block.each do |page|
          doc.li(:class => (self.page_index == page ? 'disabled' : '')) {
            doc.a(:id => "dt-page-#{page}", :onclick => ((self.page_index == page) ? 'void(0)' : "goToPage(this.id, #{page})"), :href => 'javascript: void(0)') {
              doc.span page
            }
          }
        end

        doc.li(:class => (self.has_next_page? ? '' : 'disabled')) {
          doc.a(:id => "#{table_id}-page-next", :onclick => ((self.has_next_page?) ? "goToPage(this.id, #{self.next_page})" : 'void(0)'), :href => 'javascript: void(0)') {
            doc.span '>'
          }
        }
        doc.li(:class => (self.has_next_pagination_block? ? '' : 'disabled')) {
          doc.a(:id => "#{table_id}-block-next", :onclick => ((self.has_next_pagination_block?) ? "goToPage(this.id, #{self.next_block_page})" : 'void(0)'), :href => 'javascript: void(0)') {
            doc.span '>>'
          }
        }
      }
    }

    doc.script <<-eos
      function goToPage(ui, index) {
        $('##{table_id}-index').val(index);
        $('#' + ui).closest('form').submit();
      }

      function resetPagination() {
        $('##{table_id}-index').val(null);
      }
    eos
  end

  def _bind(obj, value)
    binding = /%{.+}/.match(value)
    (binding) ? value.to_s.sub(/%{.+}/, obj.instance_eval(binding.to_s.sub('%{', '').sub('}', '')).to_s) :value
  end
  
end