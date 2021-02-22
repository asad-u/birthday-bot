class HomeController < ApplicationController
  def index
    @organizations = current_user&.organizations&.includes(:bots)
  end
end
