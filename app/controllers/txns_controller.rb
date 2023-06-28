# frozen_string_literal: true

class TxnsController < ApplicationController
  before_action :set_transaction, only: %i[add_tags delete_tags show update destroy]
  before_action :set_wallet, only: %i[create]
  before_action :set_purpose, only: %i[create]

  def add_tags
    tags = TagTxn.create(params.require(:tag_ids).map { |tag_id| { tag_id:, txn_id: @txn.id } })

    if tags.all?(&:persisted?)
      render json: tags
    else
      render json: @txn.errors, status: :unprocessable_entity
    end
  end

  # POST /txns
  def create
    @txn = Txn.new(transaction_params)

    persisted = ActiveRecord::Base.transaction do
      amount = @txn.amount.abs
      amount *= -1 if @txn.debit?

      @wallet.update({ balance: @wallet.balance + amount })

      @txn.save
    end

    if persisted
      render json: @txn, status: :created, location: @txn
    else
      render json: @txn.errors, status: :unprocessable_entity
    end
  end

  # DELETE /txns
  def delete_tags
    tags_deleted = TagTxn.where(txn_id: @txn.id, tag_id: params.require(:tag_ids)).delete_all

    render json: @txn.errors, status: :unprocessable_entity if tags_deleted.zero?
  end

  # DELETE /txns/1
  def destroy
    @txn.destroy
  end

  # GET /txns
  def index
    @txns = Txn.all

    render json: @txns
  end

  # GET /txns/1
  def show
    render json: @txn
  end

  # PATCH/PUT /txns/1
  def update
    if @txn.update(transaction_params)
      render json: @txn
    else
      render json: @txn.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_purpose
    @purpose = Purpose.find(params[:purpose_id])
  end

  def set_transaction
    @txn = Txn.find(params[:id])
  end

  def set_wallet
    @wallet = Wallet.find(params[:wallet_id])
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
