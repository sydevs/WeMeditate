module SectionHelper
  
  def markdown content, &block
    @r ||= MarkdownRenderer.new
    @r.callout = (block_given? ? capture(&block) : nil)

    @rc ||= Redcarpet::Markdown.new(@r, no_intra_emphasis: true, autolink: true, space_after_headers: true, filter_html: true)
    @rc.render(content).html_safe
  end

  class MarkdownRenderer < Redcarpet::Render::HTML
    attr_writer :callout

    def paragraph text
      if @callout
        result = %(<p>#{text}</p>#{@callout})
        @callout = nil
        result
      else
        %(<p>#{text}</p>)
      end
    end
  end

end
