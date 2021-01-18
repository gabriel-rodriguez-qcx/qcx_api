# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Serialization

  rescue_from Date::Error do
    render json: { error: 'Invalid date' }, status: 422
  end
end
