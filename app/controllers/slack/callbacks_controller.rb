module Slack
  class CallbacksController < ApplicationController
    include SlackInteraction
  end
end
