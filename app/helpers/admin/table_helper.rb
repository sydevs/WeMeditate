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
    when Category, MoodFilter, DurationFilter, GoalFilter, InstrumentFilter, Treatment
      ''
    else
      record.class
    end
  end

  def table_icons record
    capture do
      case record
      when Track
        record.instrument_filters.includes(:translations).each do |instrument_filter|
          detail = tag.div class: 'instrument', data: { tooltip: instrument_filter.name } do
            tag.img src: instrument_filter.icon.url
          end

          concat detail
        end
      when Meditation
        record.goal_filters.includes(:translations).each do |goal_filter|
          detail = tag.div class: 'goal', data: { tooltip: goal_filter.name } do
            tag.img src: goal_filter.icon.url
          end

          concat detail
        end

        concat table_icon 'eye', translate('admin.tags.views', count: record.views), record.views
      when Category
        article_count = record.articles.count
        concat table_icon 'file text', Category.human_attribute_name(:articles, count: article_count), article_count
      when MoodFilter, InstrumentFilter, Artist
        track_count = record.tracks.count
        concat table_icon 'music', record.class.human_attribute_name(:tracks, count: track_count), track_count
      when GoalFilter, DurationFilter
        meditation_count = record.meditations.count
        concat table_icon 'leaf', record.class.human_attribute_name(:meditations, count: meditation_count), meditation_count
      end
    end
  end

  def table_actions model, records
    capture do
      if model == Article
        concat table_action Category.model_name.human(count: -1), 'hashtag', admin_categories_path if policy(Category).index?
      elsif model == Track
        concat table_action InstrumentFilter.model_name.human(count: -1), 'filter', admin_instrument_filters_path if policy(InstrumentFilter).index?
        concat table_action MoodFilter.model_name.human(count: -1), 'filter', admin_mood_filters_path if policy(MoodFilter).index?
        concat table_action Artist.model_name.human(count: -1), 'user', admin_artists_path if policy(Artist).index?
      elsif model == Meditation
        concat table_action GoalFilter.model_name.human(count: -1), 'filter', admin_goal_filters_path if policy(GoalFilter).index?
        concat table_action DurationFilter.model_name.human(count: -1), 'clock', admin_duration_filters_path if policy(DurationFilter).index?
      end

      if policy(model).sort? and records.count > 1
        concat table_action translate('admin.action.target.reorder', target: model.model_name.human), 'bars', url_for([:admin, model, reorder: true])
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
        concat table_link translate('admin.action.target.back', target: parent.model_name.human(count: -1)), 'left arrow', url_for([:admin, parent])
      end

      if policy(model).new?
        concat table_link translate(model.model_name.i18n_key, scope: %i[admin action create_model target], target: model.model_name.human, default: :'admin.action.target.create'), 'plus', url_for([:new, :admin, model.model_name.singular_route_key.to_sym])
      end
    end
  end

end
