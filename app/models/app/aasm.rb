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

      event :start do
        transitions :from => :stopped, :to => :running
      end

      event :stop do
        transitions :from => :running, :to => :stopped
      end
    end

    def compose_start
      compose_rm
      system("#{ docker_compose_action } up -d")
      run!
    end

    def compose_stop
      system("#{ docker_compose_action } stop")
      stop!
    end

    def compose_rm
      system("#{ docker_compose_action } rm --force")
    end

    def compose_restart
      compose_stop
      stop!
      compose_start
      run!
    end

    private

    def docker_compose_action
      "COMPOSE_FILE=#{ compose_app_file(id) } /usr/local/bin/docker-compose"
    end

  end
end
