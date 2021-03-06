module App::Aasm
  extend ActiveSupport::Concern

  included do
    include AASM

    enum state: {
      stopped: 0,
      running: 1
    }

    aasm column: :state, enum: true do
      state :stopped
      state :running

      event :state_run do
        transitions :from => [:stopped], :to => :running
      end

      event :state_stop do
        transitions :from => :running, :to => :stopped
      end
    end


    # Main actions

    def start
      rm
      system("#{ docker_compose_action } up -d")
      state_run!
    end

    def stop
      system("#{ docker_compose_action } down")
      state_stop!
    end

    def rm
      system("#{ docker_compose_action } rm --all --force")
    end

    def restart
      stop
      start
    end

    def self.relaunch
      App.where(state: 1).each{ |app| app.restart }
    end

    def self.stop
      App.where(state: 1).each{ |app| app.stop }
    end

    def self.start
      App.where(state: 0).each{ |app| app.start }
    end

    # Database actions

    def db_drop
      docker_compose_database_action :drop
    end

    def db_create
      docker_compose_database_action :create
    end

    def db_migrate
      docker_compose_database_action :migrate
    end

    def db_seed
      docker_compose_database_action :seed
    end

    private

    def docker_compose_action
      "COMPOSE_FILE=#{ compose_app_file(slug) } docker-compose"
    end

    def docker_compose_database_action action
      system("#{ docker_compose_action } run --rm web rake db:#{ action }")
    end

  end
end
