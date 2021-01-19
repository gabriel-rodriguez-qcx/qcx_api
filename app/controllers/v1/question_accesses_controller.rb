module V1
  class QuestionAccessesController < ApplicationController
    before_action :validate_date, :validate_presence

    def index
      questions, accesses = Questions::FetchMostAccessedService.call(service_params)

      render json: questions, scope: accesses, fields: permitted_params[:fields].to_h, meta: metadata
    end

    private

    def service_params
      { year: permitted_params[:year], month: permitted_params[:month], week: permitted_params[:week] }
    end

    def permitted_params
      params.permit(:year, :month, :week, fields: {})
    end

    def metadata
      {
        month: permitted_params[:month],
        year: permitted_params[:year],
        week: permitted_params[:week]
      }.compact
    end

    def validate_date
      service_params.compact.each_value { |v| Integer(v) }
    rescue ArgumentError
      render json: { error: I18n.t('question_accesses_controller.errors.wrong_date_value') },
             status: :unprocessable_entity
    end

    def validate_presence
      return if service_params.compact.present?

      render json: { error: I18n.t('question_accesses_controller.errors.presence') }, status: :unprocessable_entity
    end
  end
end
