class SubtleSystemNodesController < ApplicationController

  before_action :redirect_subtle_system, except: %i[index]

  def index
    @static_page = StaticPage.preload_for(:content).find_by(role: :subtle_system)
    @subtle_system_nodes = SubtleSystemNode.publicly_visible
    expires_in 1.day, public: true

    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: @static_page.name },
    ]

    set_metadata(@static_page)
  end

  def show
    @subtle_system_node = SubtleSystemNode.publicly_visible.preload_for(:content).friendly.find(params[:id])
    return unless stale?(@subtle_system_node)

    subtle_system_page = StaticPage.preload_for(:preview).find_by(role: :subtle_system)
    @breadcrumbs = [
      { name: StaticPageHelper.preview_for(:home).name, url: root_path },
      { name: subtle_system_page.name, url: subtle_system_nodes_path },
      { name: @subtle_system_node.name },
    ]

    set_metadata(@subtle_system_node)
  end

  def redirect_subtle_system
    @subtle_system_node = SubtleSystemNode.friendly.find(params[:id])

    return redirect_to @subtle_system_node, status: :moved_permanently unless request.path == subtle_system_node_path(@subtle_system_node)
    end
  end

end
