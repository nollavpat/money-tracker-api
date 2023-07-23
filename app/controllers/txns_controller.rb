# frozen_string_literal: true

class TxnsController < ApplicationController
  before_action :set_transaction, only: %i[add_tags delete_tags update destroy]
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
    amount = @txn.amount
    new_wallet_balance = @wallet.balance + amount

    return render json: { status: 400, error: 'Insufficient balance' }, status: 400 if new_wallet_balance.negative?

    persisted = ActiveRecord::Base.transaction do
      @wallet.update({ balance: new_wallet_balance })

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
    render json: txns_with_relationships
  end

  # GET /txns/1
  def show
    render json: txn_with_relationships
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

  def parse_records(records)
    hash = {}

    records.each do |txn|
      if hash[txn['id']].present?
        hash[txn['id']][:tags] << txn['tag_name']
      else
        hash[txn['id']] = txn.except('tag_name')
                             .merge(tags: [txn['tag_name']].compact)
      end
    end

    hash.values
  end

  def query_txns_with_relationships(query = {})
    sql = Txn.left_outer_joins(tag_txns: [:tag])
             .joins('LEFT JOIN wallets ON wallets.id = txns.wallet_id')
             .joins('LEFT JOIN purposes ON purposes.id = txns.purpose_id')
             .where(query)
             .select('txns.id',
                     'txns.amount',
                     'txns.name',
                     'txns.created_at',
                     'txns.updated_at',
                     'tags.name as tag_name',
                     'wallets.name as wallet',
                     'purposes.name as purpose')
             .order(created_at: :desc)
             .to_sql

    ActiveRecord::Base.connection.exec_query(sql).to_a
  end

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

  def transactions_filter_params
    params
      .permit(
        :from,
        :to
      )
  end

  # Only allow a list of trusted parameters through.
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

  def txn_with_relationships
    records = query_txns_with_relationships(id: params[:id])

    parse_records(records)[0]
  end

  def txns_with_relationships
    filter = if transactions_filter_params[:from].present? && transactions_filter_params[:to].present?
               { created_at: transactions_filter_params[:from]..transactions_filter_params[:to] }
             end

    records = query_txns_with_relationships(filter)

    parse_records(records)
  end
end
