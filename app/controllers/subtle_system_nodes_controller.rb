class SubtleSystemNodesController < ApplicationController

  def index
    @static_page = StaticPage.preload_for(:content).find_by(role: :subtle_system)
    @subtle_system_nodes = SubtleSystemNode.publicly_visible
    expires_in 1.day, public: true

    @breadcrumbs = [
      { name: StaticPage.preview(:home).name, url: root_path },
      { name: @static_page.name },
    ]

    set_metadata(@static_page)
  end

  def show
    @subtle_system_node = SubtleSystemNode.publicly_visible.preload_for(:content).friendly.find(params[:id])
    return if redirect_legacy_url(@subtle_system_node)
    return unless stale?(@subtle_system_node)

    subtle_system_page = StaticPage.preload_for(:preview).find_by(role: :subtle_system)
    @breadcrumbs = [
      { name: StaticPage.preview(:home).name, url: root_path },
      { name: subtle_system_page.name, url: subtle_system_nodes_path },
      { name: @subtle_system_node.name },
    ]

    set_metadata(@subtle_system_node)
  end

end
