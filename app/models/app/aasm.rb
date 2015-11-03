module App::Aasm
  extend ActiveSupport::Concern

  included do
    include AASM

    enum state: {
      stopped: 0,
      running: 1
    }

    aasm column: :state, enum: true do
      state :stopped, initial: true
      state :running

      event :state_run do
        transitions :from => :stopped, :to => :running
      end

      event :state_stop do
        transitions :from => :running, :to => :stopped
      end
    end

    def start
      rm
      system("#{ docker_compose_action } up -d")
      state_run!
    end

    def stop
      system("#{ docker_compose_action } stop")
      state_stop!
    end

    def rm
      system("#{ docker_compose_action } rm --force")
    end

    def restart
      stop
      state_stop!
      start
      state_run!
    end

    private

    def docker_compose_action
      "COMPOSE_FILE=#{ compose_app_file(id) } /usr/local/bin/docker-compose"
    end

  end
end
