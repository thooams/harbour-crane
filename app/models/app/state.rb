module App::State

  RUNNING = :running
  STOPPED = :stopped
  STATES  = [RUNNING, STOPPED]

  def running?
    state == RUNNING
  end

  # Force state in running
  def running!
    update_attribute :state, RUNNING
  end

  def stopped!
    update_attribute :state, STOPPED
  end

end
