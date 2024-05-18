class IndexController < ApplicationController
  def index
  end

  def create
    HeavyJob.perform_later(SecureRandom.uuid)
  end
end
