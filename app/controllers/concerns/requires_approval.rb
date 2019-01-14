
module RequiresApproval
  extend ActiveSupport::Concern

  included do
    before_action :set_paper_trail_whodunnit
  end

  def review
    render 'admin/application/review'
  end

  def publish
    if params[:do] == 'publish'
      @record.publish_drafts!
    else
      @record.discard_drafts!
    end

    redirect_to [:admin, @klass]
  end

end
