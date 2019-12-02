require 'i18n_data'

# This class helps render elements for the CMS dashboard
module Admin::DashboardHelper

  # Render a full list of all current issues in the CMS
  def dashboard_issues &block
    missing Meditation, :critical, &block
    untranslated Category, :critical, &block
    untranslated GoalFilter, :critical, &block
    untranslated InstrumentFilter, :critical, &block
    # untranslated MoodFilter, :critical, &block
    untranslated StaticPage, :critical, &block
    untranslated SubtleSystemNode, :critical, &block
    pinned Article, :important, &block
    needs_review StaticPage, :important, &block
    needs_review SubtleSystemNode, :important, &block
    needs_review Treatment, :important, &block
    needs_review Article, :important, &block
    untranslated Track, :normal, &block
    unpublished Article, :normal, &block
    untranslated Treatment, :normal, &block
    untranslated Article, :normal, &block
    untranslated Meditation, :normal, &block
    pending_invite User, :pending, &block
  end

  private

    # Get a name to be shown for a given record in the issues list.
    # Some models need a bit of context.
    def record_name record
      case record
      when StaticPage, SubtleSystemNode
        # When it comes to issues the page's role is more important than the page's name for certain types
        human_enum_name(record, :role)
      when GoalFilter, MoodFilter, InstrumentFilter, DurationFilter
        # Some types need a bit of extra context to make them easy to understand
        "#{human_model_name(record)}: #{record.preview_name}"
      else
        # The rest can just show their preview name
        record.preview_name
      end
    end

    # For a given model which supports the `role` enum, list any missing records
    def missing model, urgency, &block
      if policy(model).create?
        if model == Meditation
          return unless Meditation.get(:self_realization).nil?

          block.call({
            model: model,
            name: translate('footer.self_realization'),
            url: polymorphic_path(%i[new admin meditation], slug: translate('routes.self_realization')),
            message: translate('admin.tags.missing_record', model: model),
            urgency: urgency,
          })
        else
          model.available_roles.each do |role|
            block.call({
              model: model,
              name: human_enum_name(model, :role, role),
              url: polymorphic_path([:new, :admin, model.model_name.singular_route_key.to_sym], role: role),
              message: translate('admin.tags.missing_record', model: model),
              urgency: urgency,
            })
          end
        end
      end
    end

    # For the `Article` model, render an alert if there are too many articles pinned to the top of the Inspiration page
    def pinned model, urgency, &block
      return unless model == Article

      if policy(model).publish? && model.pinned.count > 3
        block.call({
          model: model,
          name: translate('admin.tags.too_many_pinned', model: human_model_name(model, :plural).downcase, count: 3),
          url: polymorphic_path([:admin, model], filter: "priority:#{model.priorities[:pinned]}"),
          message: "#{model.pinned.count} #{human_model_name(model, :plural)}",
          urgency: urgency,
        })
      end
    end

    # List an alert for each untranslated record for a given model.
    def untranslated model, urgency, &block
      if policy(model).update_translation?
        # Only get records that can be translated by the current user
        scope = policy_scope(model).needs_translation_by(current_user)
        # scope = scope.has_no_draft if model.draftable?
        scope.each do |record|
          block.call({
            model: model,
            name: record_name(record),
            url: polymorphic_admin_path([:edit, :admin, record]),
            message: translate('admin.tags.no_translation', language: language_name),
            urgency: urgency,
          })
        end
      end
    end

    # List an alert for all in progress records that should be finished off and published.
    def unpublished model, urgency, &block
      if policy(model).review?
        policy_scope(model).not_published.not_archived.each do |record|
          block.call({
            model: model,
            name: record_name(record),
            url: polymorphic_admin_path([:edit, :admin, record]),
            message: translate('admin.tags.unpublished_draft'),
            urgency: urgency,
          })
        end
      end
    end

    # List an alert for any records which are waiting for review.
    def needs_review model, urgency, &block
      if policy(model).review?
        # Only get articles which the current user can review
        policy_scope(model).needs_review.each do |record|
          next unless record.ready_for_review? # Skip anything which is reviewable but isn't expecting review yet.
          
          block.call({
            model: model,
            name: record_name(record),
            url: polymorphic_admin_path([:review, :admin, record]),
            message: translate('admin.tags.unapproved_changes'),
            urgency: urgency,
          })
        end
      end
    end

    # For a model that supports invitation (aka Users), list any records that have not accepted their invitation yet.
    def pending_invite model, urgency, &block
      if policy(model).create?
        policy_scope(model).invitation_not_accepted.each do |record|
          next unless policy(record).edit?

          block.call({
            model: model,
            name: record_name(record),
            url: polymorphic_admin_path([:edit, :admin, record]),
            message: translate('admin.tags.pending_invitation'),
            urgency: urgency,
          })
        end
      end
    end

end
