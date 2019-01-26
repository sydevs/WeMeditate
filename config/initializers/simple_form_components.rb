require 'pathname'

module SimpleForm
  module Components
    module Decorations
      def slug_prefix wrapper_options = nil
        template.content_tag :div, "#{Pathname(options[:url]).dirname.to_s}/", class: 'ui basic label' unless options[:url].nil?
      end

      def icon wrapper_options = nil
        template.content_tag :i, '', class: "#{options[:icon]} icon" unless options[:icon].nil?
      end
    end

    module Files
      def file_labels wrapper_options = nil
        if options[:files].present? or options[:file].present?
          template.content_tag :div, class: 'ui fluid file labels' do
            content = ''
            content << file_html(options[:file]) unless options[:file].nil? or options[:file].file.nil?

            if options[:files].present?
              options[:files].each do |media|
                content << file_html(media) unless media.file.nil?
              end
            end

            content.html_safe
          end
        end
      end

      def file_html media
        template.content_tag :a, class: 'ui basic label', href: media.url, target: '_blank' do
          content = ''
          content << template.content_tag(:i, '', class: "#{options[:icon]} icon") unless options[:icon].nil?

          if defined? media.file.identifier
            content << template.content_tag(:span, media.file.identifier.humanize)
          else
            content << template.content_tag(:span, media.file.filename.humanize)
          end

          content.html_safe
        end
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Decorations)
SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Files)
