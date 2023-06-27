# frozen_string_literal: true

class PurposesController < ApplicationController
  before_action :authenticate_token
  before_action :set_purpose, only: %i[destroy show]

  # POST /purposes
  def create
    @purpose = Purpose.new(purpose_params)

    if @purpose.save
      render json: @purpose, status: :created, location: @purpose
    else
      render json: @purpose.errors, status: :unprocessable_entity
    end
  end

  # DELETE /purposes/1
  def destroy
    @purpose.destroy
  end

  # GET /purposes
  def index
    @purposes = Purpose.all

    render json: @purposes
  end

  # GET /purposes/1
  def show
    render json: @purpose
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_purpose
    @purpose = Purpose.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def purpose_params
    params.require(:purpose).permit(:name)
  end
end
