require 'i18n_data'

module Admin
  module DashboardHelper

    def dashboard_issues &block
      missing Meditation, :critical, &block
      untranslated Category, :critical, &block
      untranslated GoalFilter, :critical, &block
      untranslated InstrumentFilter, :critical, &block
      # untranslated MoodFilter, :critical, &block
      untranslated StaticPage, :critical, &block
      untranslated SubtleSystemNode, :critical, &block
      needs_review StaticPage, :important, &block
      needs_review SubtleSystemNode, :important, &block
      needs_review Treatment, :important, &block
      needs_review Article, :important, &block
      unpublished Article, :normal, &block
      untranslated Treatment, :normal, &block
      untranslated Article, :normal, &block
      untranslated Meditation, :normal, &block
      pending_invite User, :pending, &block
    end

    private

      def record_name record
        case record
        when StaticPage, SubtleSystemNode
          human_enum_name(record, :role)
        when GoalFilter, MoodFilter, InstrumentFilter
          "#{human_model_name(record)}: #{record.preview_name}"
        else
          record.preview_name
        end
      end

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

      def untranslated model, urgency, &block
        if policy(model).update_translation?
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

      def needs_review model, urgency, &block
        if policy(model).review?
          policy_scope(model).needs_review.each do |record|
            next unless record.ready_for_review?
            
            block.call({
              model: model,
              name: record_name(record),
              message: translate('admin.tags.unapproved_changes'),
              urgency: urgency,
            })
          end
        end
      end

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
end

