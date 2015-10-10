require_dependency "sagashi/application_controller"

module Sagashi
  class TokensController < ApplicationController
    # GET /tokens
    def index
      @tokens = Sagashi::Token.all
    end
  end
end
