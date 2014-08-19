module Epistoleiro
  class App
    module AppHelper

      def put_message(options)
        message = I18n.translate options[:message]
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

      def has_system_message?
        return !params[:msg].nil? && !params[:msg].empty?
      end

      def show_messages
        ui = <<eos    
<div class="#msg_type alert-dismissable">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <b>#title</b>
  <div>
    #msg
  </div>
</div>
eos
        msg_type, title = case params[:msg_type]
          when ('i' || nil || '') then ['alert alert-info', I18n.translate('view.message_type.info')]
          when 's' then ['alert alert-success', I18n.translate('view.message_type.success')]
          when 'w' then ['alert alert-warning', I18n.translate('view.message_type.warn')]
          when 'e' then ['alert alert-danger', I18n.translate('view.message_type.error')]
          else ['', '']
        end

        ui.sub! /#msg_type/, msg_type
        ui.sub! /#title/, title
        ui.sub! /#msg/, params[:msg]
      end

    end

    helpers AppHelper
  end
end