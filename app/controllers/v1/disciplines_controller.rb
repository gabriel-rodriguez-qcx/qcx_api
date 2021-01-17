module V1
  class DisciplinesController < ApplicationController
    def index
      render json: Disciplines::FetchMostAccessedService.call
    end
  end
end
