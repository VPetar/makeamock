class ErrorsController < ApplicationController
  def not_found
    render inertia: "404", status: :not_found
  end
end
