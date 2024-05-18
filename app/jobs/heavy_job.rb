class HeavyJob < ApplicationJob
  queue_as 'activejob-queue'

  def perform(*params)
    sleep 3
  end
end
