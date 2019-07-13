require 'i18n_data'

module Admin
  module PermissionsHelper

    ICONS = {
      create: 'plus',
      update: 'wrench',
      publish: 'checkmark',
      destroy: 'warning sign',
    }.freeze

    DEFAULT_TEXT = {
      create: 'Can Create',
      update: 'Can Modify',
      publish: 'Can Approve Changes',
      destroy: 'Can Delete',
    }

    MATRIX = {
      article: {
        translator: %i[update],
        editor: {
          # TODO: Translation
          update: 'Can Modify Own Items',
          publish: 'Can Approve Changes to Own Items',
          create: true,
        },
        regional_admin: %i[update publish create],
        super_admin: %i[update publish create destroy],
      },
      static_page: {
        translator: %i[update],
        editor: [],
        regional_admin: %i[update publish],
        super_admin: %i[update publish],
      },
      subtle_system_node: {
        translator: %i[update],
        editor: [],
        regional_admin: %i[update publish],
        super_admin: %i[update publish],
      },

      meditation: {
        translator: [],
        editor: [],
        regional_admin: %i[update publish create],
        super_admin: %i[update publish create destroy],
      },
      treatment: {
        translator: %i[update],
        editor: [],
        regional_admin: %i[update publish create],
        super_admin: %i[update publish create destroy],
      },
      track: {
        translator: [],
        editor: [],
        regional_admin: [],
        super_admin: %i[update publish create destroy],
      },

      category: {
        translator: [],
        editor: [],
        regional_admin: %i[update publish],
        super_admin: %i[update publish create destroy],
      },
      goal_filter: {
        translator: [],
        editor: [],
        regional_admin: %i[update publish],
        super_admin: %i[update publish create destroy],
      },
      duration_filter: {
        translator: [],
        editor: [],
        regional_admin: [],
        super_admin: %i[update publish create destroy],
      },
      mood_filter: {
        translator: [],
        editor: [],
        regional_admin: [],
        super_admin: %i[update publish create destroy],
      },
      instrument_filter: {
        translator: [],
        editor: [],
        regional_admin: [],
        super_admin: %i[update publish create destroy],
      },
      artist: {
        translator: [],
        editor: [],
        regional_admin: [],
        super_admin: %i[update publish create destroy],
      },

      user: {
        translator: [],
        editor: [],
        regional_admin: {
          # TODO: Translation
          update: 'Can Modify Writers and Translators',
          create: 'Can Create Writers and Translators',
        },
        super_admin: %i[update create destroy],
      },
    }.freeze

    def permissions_matrix roles
      capture do
        MATRIX.each do |model, permission_set|
          concat permission_row(model, permission_set)
        end
      end
    end

    private

      def permission_row model, permission_set
        content_tag :tr do
          concat tag.td(translate model, scope: %i[activerecord models], count: -1)
          permission_set.values.each do |permissions|
            concat tag.td(permission_icons(permissions))
          end
        end
      end

      def permission_icons permissions
        capture do
          if permissions.is_a? Array
            permissions.each do |permission|
              concat permission_icon(permission, DEFAULT_TEXT[permission])
            end
          else
            permissions.each do |permission, value|
              if value == true
                concat permission_icon(permission, DEFAULT_TEXT[permission])
              else
                concat permission_icon(permission, value, partial: true)
              end
            end
          end
        end
      end

      def permission_icon type, label, partial: false
        icon = tag.i class: "#{ICONS[type]}#{' disabled' if partial} icon"
        tag.span icon, data: { tooltip: label }
      end

  end
end

