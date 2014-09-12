module Epistoleiro
  class App
    module AppHelper

      def put_message(options)
        message = ((options[:translate] == false) ? options[:message] : I18n.translate(options[:message]))
        options[:params].each {|k, v| message.sub! k, v } if options[:params]

        params[:msg] = message
        params[:msg_type] = options[:type]
      end

      def format_validation_messages(entity)
        messages = entity.errors.messages
        return [] if messages.empty?
        
        msg = []
        messages.each_key {|k| messages[k].each {|e| msg << e }}
        msg
      end

      def array_to_html_list(array, type='ul')
        html = "<#{type}>"
        array.each {|e| html << "<li>#{e}</li>" }
        html << "</#{type}>"
      end

      def has_system_message?
        has_request_messages? || has_session_messages?
      end

      def has_request_messages?
        !params[:msg].nil? && !params[:msg].empty?
      end

      def has_session_messages?
        !session[:msg].nil? && !session[:msg].empty?
      end

      def show_messages
        messages = ''
        messages << show_request_messages if has_request_messages?
        messages << show_session_messages if has_session_messages?
        messages
      end

      def show_request_messages
        _show_messages params[:msg], params[:msg_type]
      end

      def show_session_messages
        messages = _show_messages session[:msg], session[:msg_type]
        session[:msg] = session[:msg_type] = nil
        messages
      end

      def _show_messages(message, type)
        ui = <<eos    
<div class="#msg_type alert-dismissable">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <b>#title</b>
  <div>
    #msg
  </div>
</div>
eos
        msg_type, title = case type
          when ('i' || nil || '') then ['alert alert-info', I18n.translate('view.message_type.info')]
          when 's' then ['alert alert-success', I18n.translate('view.message_type.success')]
          when 'w' then ['alert alert-warning', I18n.translate('view.message_type.warn')]
          when 'e' then ['alert alert-danger', I18n.translate('view.message_type.error')]
          else ['', '']
        end

        ui.sub! /#msg_type/, msg_type
        ui.sub! /#title/, title
        ui.sub! /#msg/, message
      end

    end

    helpers AppHelper
  end
end