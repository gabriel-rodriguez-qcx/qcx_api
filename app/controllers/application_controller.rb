# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Serialization

  rescue_from Date::Error do
    render json: { error: 'Invalid date' }, status: :unprocessable_entity
  end
end
