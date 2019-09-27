namespace :wm do
  desc "This task is called by the Heroku scheduler add-on"
  task :decay_popularity => :environment do
    Meditation::Translation.where('popularity > 1').find_each do |meditation|
      meditation.update! popularity: meditation.popularity * 0.8
    end
  end
end