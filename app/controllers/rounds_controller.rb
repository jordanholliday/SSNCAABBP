class RoundsController < ApplicationController
  before_action :redirect_unless_admin

  def index
    @rounds = Round.all.sort
  end
end
