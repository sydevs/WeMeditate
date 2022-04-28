namespace :wm do
  desc 'This task is called by the Heroku scheduler add-on'
  task decay_popularity: :environment do
    Meditation::Translation.where('popularity > 1').find_each do |meditation|
      meditation.update! popularity: meditation.popularity * 0.8
    end
  end

  # TODO: Remove deprecated rake tasks
  namespace :vimeo do
    desc 'Reload the vimeo metadata for all records'
    task reset: :environment do
      Rake::Task['wm:vimeo:reset:meditations'].invoke
    end

    namespace :reset do
      desc 'Reload the vimeo metadata for meditations only'
      task :meditations, %i[locale] => :environment do |_, args|
        args.with_defaults(locale: 'en')
        I18n.locale = args.locale.to_sym
        Globalize.locale = I18n.locale

        Meditation.in_batches(of: 200).each_with_index do |group, index|
          puts "Updating Meditations Vimeo Metadata (#{I18n.locale.upcase} Group #{index + 1})..."
          group.each do |record|
            next if !record.horizontal_vimeo_id? && !record.vertical_vimeo_id?

            record.vimeo_metadata = {
              horizontal: (Vimeo.retrieve_metadata(record.horizontal_vimeo_id) if record.horizontal_vimeo_id),
              vertical: (Vimeo.retrieve_metadata(record.vertical_vimeo_id) if record.vertical_vimeo_id),
            }

            record.save!(touch: false, validate: false)
          end

          # Wait for 60 second to avoid the rate limit
          sleep 60 unless group.count < 200 # If there are less than 200 in the group, then we should be at the end.
        end
      end
    end
  end
end