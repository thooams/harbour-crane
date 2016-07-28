namespace :proxy do
  desc "Create App server Nginx and start"
  task create: :environment do
    App.create_and_start_proxy
  end

  desc "Destroy App server Nginx and compose file"
  task destroy: :environment do
    App.destroy_proxy
  end
end
