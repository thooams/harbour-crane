namespace :apps do
  desc "Relaunch all apps previously ran"
  task relaunch: :environment do
    App.relaunch
  end
end
