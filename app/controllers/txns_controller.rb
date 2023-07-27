# frozen_string_literal: true

class TxnsController < ApplicationController
  before_action :set_transaction, only: %i[add_tags delete_tags update destroy]
  before_action :set_wallet, only: %i[create create_payment]
  before_action :set_purpose, only: %i[create]

  # POST /txns
  def add_tags
    tags = TagTxn.create!(params.require(:tag_ids).map { |tag_id| { tag_id:, txn_id: @txn.id } })

    if tags.all?(&:persisted?)
      render json: tags
    else
      render json: @txn.errors, status: :unprocessable_entity
    end
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

  # POST /txns/payments
  def create_payment
    payment = PaymentTransaction.pay_txns(
      name: params[:name],
      txn_ids: params[:txn_ids],
      wallet: @wallet
    )

    render json: payment, status: :created, location: payment
  rescue PaymentTransaction::AlreadyPaid,
         PaymentTransaction::DebitExpense,
         PaymentTransaction::EmptyTxns,
         PaymentTransaction::MultipleBanks => e
    render json: { message: e.message }, status: 400
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
    filter = { 'wallets.direction': index_params[:direction] }

    if index_params[:from].present? && index_params[:to].present?
      filter.merge!({ created_at: index_params[:from]..index_params[:to] })
    end

    render json: Txn.with_relationships(filter.compact)
  end

  # GET /txns/1
  def show
    render json: Txn.with_relationships(id: params[:id]).first
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

  # Params

  def payment_params
    params
      .permit(
        :name,
        :txn_ids,
        :wallet_id
      )
  end

  def index_params
    params
      .permit(
        :direction,
        :from,
        :to
      )
  end

  def transaction_params
    params
      .require(:txn)
      .permit(
        :amount,
        :category,
        :name,
        :purpose_id,
        :wallet_id
      )
  end

  # Callbacks
  def set_purpose
    @purpose = Purpose.find(params[:purpose_id])
  end

  def set_transaction
    @txn = Txn.find(params[:id])
  end

  def set_wallet
    @wallet = Wallet.find(params[:wallet_id])
  end
end
