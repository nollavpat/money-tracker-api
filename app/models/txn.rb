# frozen_string_literal: true

class Txn < ApplicationRecord
  has_one :wallet
  has_one :purpose
  has_many :tag_txns
  has_many :tags, through: :tag_txns

  enum :category, %i[need want]

  def self.with_relationships(query)
    sql = Txn.left_outer_joins(tag_txns: [:tag])
             .joins('LEFT JOIN wallets ON wallets.id = txns.wallet_id')
             .joins('LEFT JOIN purposes ON purposes.id = txns.purpose_id')
             .joins('LEFT JOIN payment_transactions ON payment_transactions.expense_id = txns.id')
             .where(query)
             .select('txns.id',
                     'txns.amount',
                     'txns.name',
                     'txns.created_at',
                     'txns.updated_at',
                     'tags.name AS tag_name',
                     'wallets.direction AS wallet_direction',
                     'wallets.logo_url AS wallet_logo_url',
                     'wallets.name AS wallet_name',
                     'purposes.name AS purpose',
                     '(CASE WHEN payment_transactions.id IS NOT NULL THEN TRUE ELSE FALSE END) AS paid')
             .order(created_at: :desc)
             .to_sql

    txns = ActiveRecord::Base.connection.exec_query(sql).to_a

    parse_txns(txns)
  end

  private_class_method def self.build_txn(txn)
    txn.except('tag_name', 'wallet_direction', 'wallet_name', 'wallet_logo_url')
       .reject { |k| k == 'paid' && txn['wallet_direction'] != 0 }
       .merge(
         {
           tags: txn['tag_name'].present? ? [txn['tag_name']] : [],
           wallet: {
             direction: Wallet.directions.key(txn['wallet_direction']),
             name: txn['wallet_name'],
             logo_url: txn['wallet_logo_url']
           }
         }
       )
  end

  private_class_method def self.parse_txns(txns)
    hash = {}

    txns.each do |txn|
      if hash[txn['id']].present?
        hash[txn['id']][:tags] << txn['tag_name']
      else
        hash[txn['id']] = build_txn(txn)
      end
    end

    hash.values
  end
end
