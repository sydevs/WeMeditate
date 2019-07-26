require 'uri'

module Admin::TableHelper

  def table_icon icon, tooltip, value = nil
    tag.span data: { tooltip: tooltip, position: 'top right' } do
      concat tag.i class: "#{icon}#{' fitted' unless value} icon"
      concat value
    end
  end

  def table_action label, icon, url, classes = nil, new_tab = false
    tag.a class: "ui tiny compact basic labeled icon button #{classes}", href: url, target: ('_blank' if new_tab).to_s do
      concat tag.i class: "#{icon} icon"
      concat label
    end
  end

  def table_link label, icon, url
    tag.a class: 'ui compact basic button', href: url do
      concat tag.i class: "#{icon} icon"
      concat label
    end
  end

  def table_detail record
    case record
    when Article
      record.category.name
    when StaticPage, SubtleSystemNode, User
      human_enum_name(record, :role)
    when Track
      record.artist.name
    when Meditation
      "~#{record.duration_filter.name}"
    when Artist
      URI(record.url).host
    when Author
      record.user&.name
    when Category, MoodFilter, DurationFilter, GoalFilter, InstrumentFilter, Treatment
      ''
    else
      record.class
    end
  end

  def table_icons record
    allow = policy(record)

    capture do
      if record.respond_to?(:translated_locales)
        if record.translated_locales.include?(I18n.locale)
          if record.respond_to?(:published_at) && record.get_localized_attribute(:published_at).nil?
            status = table_icon "#{'orange' if allow.publish?} warning sign", translate('admin.tags.pending_translation', language: language_name)
          end
        else
          status = table_icon "orange warning sign", translate('admin.tags.no_translation', language: language_name)
        end
      end

      unless status
        if record.reviewable?
          if !(record.has_attribute?(:published) ? record.published : true)
            status = table_icon 'disabled dot circle', translate('admin.tags.unpublished_draft')
          elsif record.has_draft?
            status = table_icon "#{'orange' if allow.publish?} exclamation circle", translate('admin.tags.unpublished_changes')
          else
            status = table_icon 'check circle', translate('admin.tags.published')
          end
        elsif record.has_attribute?(:published) && !record.published
          status = table_icon 'disabled hide', translate('admin.tags.unpublished_draft')
        end
      end

      concat status
  
      case record
      when Category, Author
        article_count = record.articles.count
        concat table_icon 'file text', Category.human_attribute_name(:articles, count: article_count), article_count
      when MoodFilter, InstrumentFilter, Artist
        track_count = record.tracks.count
        concat table_icon 'music', record.class.human_attribute_name(:tracks, count: track_count), track_count
      when GoalFilter, DurationFilter
        meditation_count = record.meditations.count
        concat table_icon 'leaf', record.class.human_attribute_name(:meditations, count: meditation_count), meditation_count
      when User
        concat table_icon 'question', translate('admin.tags.pending_invitation') if record.pending_invitation?
        concat table_icon 'globe', record.available_languages.map { |lang| language_name(lang) }.join(', ')
      end
    end
  end

  def table_actions model, records
    capture do
      if model == Article
        concat table_action Category.model_name.human(count: -1), model_icon_key(Category), admin_categories_path if policy(Category).index?
      elsif model == Track
        concat table_action InstrumentFilter.model_name.human(count: -1), model_icon_key(InstrumentFilter), admin_instrument_filters_path if policy(InstrumentFilter).index?
        concat table_action MoodFilter.model_name.human(count: -1), model_icon_key(MoodFilter), admin_mood_filters_path if policy(MoodFilter).index?
        concat table_action Artist.model_name.human(count: -1), model_icon_key(Artist), admin_artists_path if policy(Artist).index?
      elsif model == Meditation
        concat table_action GoalFilter.model_name.human(count: -1), model_icon_key(GoalFilter), admin_goal_filters_path if policy(GoalFilter).index?
        concat table_action DurationFilter.model_name.human(count: -1), model_icon_key(DurationFilter), admin_duration_filters_path if policy(DurationFilter).index?
      end

      if policy(model).sort? && records.count > 1
        concat table_action translate('admin.action.target.reorder', target: model.model_name.human), 'bars', polymorphic_admin_path([:admin, model], reorder: true)
      end
    end
  end

  def table_navigation model
    parent = nil

    if [MoodFilter, InstrumentFilter, Artist].include? model
      parent = Track
    elsif [GoalFilter, DurationFilter].include? model
      parent = Meditation
    elsif Category == model
      parent = Article
    end

    capture do
      if parent
        concat table_link translate('admin.action.target.back', target: parent.model_name.human(count: -1)), 'left arrow', polymorphic_admin_path([:admin, parent])
      end

      if policy(model).new?
        label = translate('create', scope: %i[admin action target], target: model.model_name.human)
        concat table_link label, 'plus', polymorphic_path([:new, :admin, model.model_name.singular_route_key.to_sym])
      end
    end
  end

end
