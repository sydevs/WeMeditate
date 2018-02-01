
module RequireApproval

  def self.included base
    #base.paper_trail_options[:on] << :update
    #base.after_update :cycle_versions, if: Proc.new{ |r| !r.skip_version_cycle? }
  end

  def published?
    published_at != nil
  end

  def draft?
    drafts.present?
  end

  def live
    paper_trail.version_at(published_at)
  end

  def drafts
    @drafts ||= begin
      if published?
        self.versions.where('created_at > ?', published_at)
      else
        self.versions
      end
    end
  end

  def publish_drafts!
    update_attribute(:published_at, DateTime.now)
    self.versions.where(['created_at < ?', self.versions.last.created_at]).delete_all
  end

  def discard_drafts!
    self.versions.where(['created_at > ?', published_at]).delete_all
  end

end
