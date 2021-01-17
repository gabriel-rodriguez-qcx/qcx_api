module V1
  class QuestionAccessesController < ApplicationController
    def index
      questions, accesses =
        Questions::FetchMostAccessedService.call(
          year: params[:year], month: params[:month], week: params[:week]
        )

      render json: questions, scope: accesses, fields: permitted_params[:fields].to_h, meta: metadata
    end

    def permitted_params
      params.permit(fields: {})
    end

    def metadata
      {
        month: params[:month],
        year: params[:year],
        week: params[:week]
      }.compact
    end
  end
end
