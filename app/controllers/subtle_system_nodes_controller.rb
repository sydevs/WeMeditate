class SubtleSystemNodesController < ApplicationController

  def index
    @static_page = StaticPage.includes(:sections).find_by(role: :subtle_system)
    @metatags = @static_page.get_metatags
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: @static_page.title }
    ]
  end

  def show
    @subtle_system_node = SubtleSystemNode.friendly.find(params[:id])
    subtle_system_page = StaticPage.find_by(role: :subtle_system)
    @metatags = @subtle_system_node.get_metatags
    @breadcrumbs = [
      { name: 'Home', url: root_path },
      { name: subtle_system_page.title, url: subtle_system_nodes_path },
      { name: @subtle_system_node.name }
    ]
  end

end
