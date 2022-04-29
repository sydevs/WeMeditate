require 'uri'

# This helper provides functions to render the tables that are shown in the index page for each model.
module Admin::TableHelper

  # A list of what columns are rendered for each model.
  TABLE_COLUMNS = {
    # Pages
    static_pages: %i[name role updated_at status],
    promo_pages: %i[name slug updated_at status],
    articles: %i[name category_id updated_at status],
    subtle_system_nodes: %i[name node updated_at status],
    streams: %i[name location updated_at status],
    # Resources
    meditations: %i[name categories popularity updated_at status],
    treatments: %i[name updated_at status],
    tracks: %i[name artist_id duration instruments_count status],
    # Filters
    categories: %i[name articles_count status],
    goal_filters: %i[name meditations_count status],
    duration_filters: %i[minutes meditations_count status],
    instrument_filters: %i[name tracks_count status],
    mood_filters: %i[name tracks_count status],
    artists: %i[name tracks_count status],
    # People
    authors: %i[name articles_count country_code account],
    users: %i[name role last_sign_in_at status],
  }.freeze

  # A list of what attributes a record can be sorted by
  # TODO: Implement the missing sortings which are shown as comments on each of the following entries.
  SORTABLE_COLUMNS = {
    # Pages
    static_pages: %i[updated_at], # %i[name updated_at],
    promo_pages: %i[updated_at], # %i[name updated_at],
    articles: %i[name updated_at created_at],
    subtle_system_nodes: %i[updated_at], # %i[name updated_at],
    streams: %i[name updated_at created_at],
    # Resources
    meditations: %i[updated_at created_at], # %i[name popularity updated_at created_at],
    treatments: %i[name updated_at created_at],
    tracks: %i[name duration created_at],
    # Filters
    categories: %i[name], # %i[name articles_count],
    goal_filters: %i[name], # %i[name meditations_count],
    duration_filters: %i[], # %i[meditations_count],
    instrument_filters: %i[name], # %i[name tracks_count],
    mood_filters: %i[name], # %i[name tracks_count],
    artists: %i[name], # %i[name tracks_count],
    # People
    authors: %i[name country_code], # %i[name country_code articles_count],
    users: %i[name last_sign_in_at role],
  }.freeze

  # A list of what attributes a record can be filtered by
  # TODO: Implement the missing filterings which are shown as comments on each of the following entries.
  FILTERABLE_COLUMNS = {
    # Pages
    static_pages: %i[status],
    promo_pages: %i[status],
    articles: %i[category_id priority status],
    subtle_system_nodes: %i[status],
    streams: %i[status],
    # Resources
    meditations: %i[status duration_filter_id], # %i[status duration_filter_id goal_filter_ids],
    treatments: %i[status],
    tracks: %i[status], # %i[status artist_ids instrument_filter_ids mood_filter_ids],
    # Filters
    categories: %i[status],
    goal_filters: %i[status],
    duration_filters: %i[status],
    instrument_filters: %i[status],
    mood_filters: %i[status],
    artists: %i[status],
    # People
    authors: %i[status],
    users: %i[role status], # %i[role language status],
  }.freeze

  # Defines styling for different record states.
  STATUS_STYLE = {
    # For `reviewable?` records
    needs_review: %i[basic orange],
    # For `translatable?` records
    needs_translation: %i[basic red],
    not_translated: %i[basic],
    # For `stateable?` records
    no_state: %i[basic],
    in_progress: %i[basic],
    published: %i[basic blue],
    archived: %i[],
    unpublished: %i[basic],
    # For `publishable?` records
    public: %i[basic blue],
    private: %i[basic],
    # For users
    active: %i[basic blue],
    inactive: %i[basic],
    pending: %i[basic orange],
    this_is_you: %i[blue],
  }.freeze

  # Yield all the columns for a certain model's table
  def table_columns model, original_locale: false, &_block
    columns = TABLE_COLUMNS[model.model_name.route_key.to_sym].clone
    columns << :original_locale if original_locale
    columns.each_with_index do |column, index|
      yield column, index
    end
  end

  # Yield all the sortable columns for a certain model's table
  def table_sortable_columns model, &_block
    SORTABLE_COLUMNS[model.model_name.route_key.to_sym].each do |column|
      yield column
    end
  end

  # Yield all the filterable columns for a certain model's table
  def table_filterable_columns model, &block
    @table_filterable_columns ||= {}
    @table_filterable_columns[model] ||= begin
      columns = {}
      FILTERABLE_COLUMNS[model.model_name.route_key.to_sym].each do |column|
        # Each column must also provide the valid values that the filter can be set to
        columns[column] = begin
          # Different types of columns require slightly different methods to determine the valid values
          if column == :status
            if model == User
              values = %i[active inactive pending]
            elsif model.stateable?
              values = %i[published in_progress not_published archived]
            else
              values = %i[published not_published]
            end

            values << :no_state if model.translatable?
            values << :needs_review if model.draftable?

            values.map { |v| [v.to_s, translate(v, scope: %i[admin index status])] }.to_h
          elsif column.to_s.ends_with?('_id')
            column.to_s.delete_suffix('_id').classify.constantize.all.map { |c| [c.id.to_s, c.preview_name] }.to_h
          elsif column.to_s.ends_with?('_ids')
            column.to_s.delete_suffix('_ids').classify.constantize.all.map { |c| [c.id.to_s, c.preview_name] }.to_h
          else # Enum
            @model.send(column.to_s.pluralize).keys.map { |v| [v.to_s, human_enum_name(@model, column, v)] }.to_h
          end
        end
      end

      columns
    end

    # If a rendering block was provided then yield all the results to the block in turn.
    if block.present?
      @table_filterable_columns[model].each do |column, values|
        yield column, values
      end
    end

    # Return the list of filterable columns at the end
    @table_filterable_columns[model]
  end

  # Compose the label for a given filter value.
  # The filter will appear in a format similar to `category:articles` or `status:archived`
  def table_filterable_label model, value
    return nil unless value.present?

    value = value.split(':')
    column = value[0].to_sym
    return human_attribute_name(model, column) unless FILTERABLE_COLUMNS[model.model_name.route_key.to_sym].include?(column)

    value = value[1].to_s
    column_name = column != :status ? human_attribute_name(@model, column) : translate('admin.index.attribute.status')
    value_name = table_filterable_columns(model)[column][value]
    return translate('admin.index.attribute.none') unless value_name.present?

    "#{column_name}: #{value_name}"
  end

  # Render the status fo a given record
  def table_record_status_label record
    status = table_record_status(record)
    return unless STATUS_STYLE.key?(status)

    label = translate(status, scope: %i[admin index status])
    tag.div label, class: "ui fluid mini #{STATUS_STYLE[status].join(' ')} label"
  end

  # Determine the status of a given record
  def table_record_status record, review: true
    @table_record_status ||= {}
    @table_record_status[record] ||= begin
      if record.is_a?(User)
        if record == current_user
          :this_is_you
        elsif record.pending_invitation?
          :pending
        elsif record.active?
          :active
        else
          :inactive
        end
      elsif review && record.draftable? && record.needs_review? && policy(record).review?
        :needs_review
      elsif record.translatable? && record.needs_translation_by?(current_user)
        :needs_translation
      elsif record.translatable? && !record.has_translation?
        :not_translated
      elsif record.stateable?
        record.state&.to_sym || 'null'
      elsif record.publishable?
        record.published? ? :public : :private
      else
        :public
      end
    end
  end

  # Render a generic icon with a tooltip and optional value for the table.
  def table_icon icon, tooltip, value = nil
    tag.span data: { tooltip: tooltip, position: 'top right' } do
      concat tag.i class: "#{icon}#{' fitted' unless value} icon"
      concat value
    end
  end

  # Render an action which can be performed on the table.
  def table_action label, icon, url, classes = nil, new_tab = false
    tag.a class: "ui tiny compact basic labeled icon button #{classes}", href: url, target: ('_blank' if new_tab).to_s do
      concat tag.i class: "#{icon} icon"
      concat label
    end
  end

  # Render a link (usually a back link) for the table
  def table_link label, icon, url
    tag.a class: 'ui compact basic button', href: url do
      concat tag.i class: "#{icon} icon"
      concat label
    end
  end

  # Render the standard set of table actions for any given model
  def table_actions model, records
    capture do
      if model == Article
        concat table_action human_model_name(Category, :plural), model_icon_key(Category), admin_categories_path if policy(Category).index?
      elsif model == Track
        concat table_action human_model_name(InstrumentFilter, :plural), model_icon_key(InstrumentFilter), admin_instrument_filters_path if policy(InstrumentFilter).index?
        # concat table_action human_model_name(MoodFilter, :plural), model_icon_key(MoodFilter), admin_mood_filters_path if policy(MoodFilter).index?
        concat table_action human_model_name(Artist, :plural), model_icon_key(Artist), admin_artists_path if policy(Artist).index?
      elsif model == Meditation
        concat table_action human_model_name(GoalFilter, :plural), model_icon_key(GoalFilter), admin_goal_filters_path if policy(GoalFilter).index?
        concat table_action human_model_name(DurationFilter, :plural), model_icon_key(DurationFilter), admin_duration_filters_path if policy(DurationFilter).index?
      end

      # If the model is sortable and has at least one record, we need to render the sorting button
      if policy(model).sort? && records.count > 1
        concat table_action translate('admin.action.target.reorder', record: human_model_name(model)), 'bars', polymorphic_admin_path([:admin, model], reorder: true)
      end
    end
  end

  # Render the navigation links for a given model's table
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
        concat table_link translate('admin.action.target.back', records: human_model_name(parent, :plural)), 'left arrow', polymorphic_admin_path([:admin, parent])
      end
    end
  end

end
