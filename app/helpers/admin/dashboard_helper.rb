require 'i18n_data'

module Admin
  module DashboardHelper

    def dashboard_issues &block
      untranslated Category, :critical, &block
      untranslated MoodFilter, :critical, &block
      untranslated InstrumentFilter, :critical, &block
      # untranslated GoalFilter, :critical, &block
      untranslated StaticPage, :critical, &block
      untranslated SubtleSystemNode, :critical, &block
      needs_review StaticPage, :important, &block
      needs_review SubtleSystemNode, :important, &block
      needs_review Article, :important, &block
      unpublished Article, :normal, &block
      untranslated Treatment, :normal, &block
      untranslated Article, :normal, &block
      untranslated Meditation, :normal, &block
    end

    private

      def record_name record
        case record
        when StaticPage, SubtleSystemNode
          human_enum_name(record, :role)
        when GoalFilter, MoodFilter, InstrumentFilter
          "#{record.model_name.human}: #{record.name}"
        else
          record.name
        end
      end

      def untranslated model, urgency, &block
        if policy(model).update_translation?
          policy_scope(model).untranslated.each do |record|
            block.call({
              model: model,
              name: record_name(record),
              url: url_for([:edit, :admin, record]),
              message: translate('admin.tags.no_translation', language: language_name),
              urgency: urgency,
            })
          end
        end
      end

      def unpublished model, urgency, &block
        if policy(model).review?
          policy_scope(model).where.not(published: false).each do |record|
            block.call({
              model: model,
              name: record_name(record),
              url: url_for([:review, :admin, record]),
              message: translate('admin.tags.unpublished_draft'),
              urgency: urgency,
            })
          end
        end
      end

      def needs_review model, urgency, &block
        if policy(model).review?
          policy_scope(model).where.not(draft: nil).each do |record|
            block.call({
              model: model,
              name: record_name(record),
              url: url_for([:review, :admin, record]),
              message: translate('admin.tags.unpublished_changes'),
              urgency: urgency,
            })
          end
        end
      end

  end
end

