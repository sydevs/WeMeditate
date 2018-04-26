module SectionHelper

  def subtle_system_pages
    StaticPage.where(role: [:chakra_1, :chakra_2, :chakra_3, :chakra_3b, :chakra_4, :chakra_5, :chakra_6, :chakra_7, :channel_left, :channel_right, :channel_center])
  end

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
