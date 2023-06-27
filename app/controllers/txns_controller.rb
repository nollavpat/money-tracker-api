# frozen_string_literal: true

class TxnsController < ApplicationController
  before_action :set_transaction, only: %i[show update destroy]

  # GET /txns
  def index
    @txns = Txn.all

    render json: @txns
  end

  # GET /txns/1
  def show
    render json: @txn
  end

  # POST /txns
  def create
    @txn = Txn.new(transaction_params)

    if @txn.save
      render json: @txn, status: :created, location: @txn
    else
      render json: @txn.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /txns/1
  def update
    if @txn.update(transaction_params)
      render json: @txn
    else
      render json: @txn.errors, status: :unprocessable_entity
    end
  end

  # DELETE /txns/1
  def destroy
    @txn.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @txn = Txn.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params
      .require(:txn)
      .permit(
        :amount,
        :category,
        :direction,
        :name,
        :purpose_id,
        :wallet_id
      )
  end
end
