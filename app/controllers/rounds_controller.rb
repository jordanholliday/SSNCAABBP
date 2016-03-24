class RoundsController < ApplicationController
  before_action :redirect_unless_admin

  def index
    @rounds = Round.where("picks_end < ?", DateTime.now + 24.hours).order(id: :desc).limit(2).reverse
  end
end
