# frozen_string_literal: true

class PaymentTransaction < ApplicationRecord
  belongs_to :expense, class_name: 'Txn', foreign_key: :expense_id
  belongs_to :payment, class_name: 'Txn', foreign_key: :payment_id

  def self.pay_txns(name:, txn_ids:, wallet:)
    return { message: 'No transactions.' } if txn_ids.empty?
    return { message: 'All transactions should have the same wallet_id.' } unless only_one_bank?(txn_ids)
    return { message: 'Trasactions are not a credit expense.' } if not_a_credit_expense(txn_ids)

    purpose = Purpose.find_by(name: 'cc_payment')

    ActiveRecord::Base.transaction do
      payment = Txn.create(
        {
          name:,
          amount: Txn.where(id: txn_ids).sum(:amount),
          category: 'need',
          purpose_id: purpose.id,
          wallet_id: wallet.id
        }
      )

      PaymentTransaction.create!(txn_ids.map { |txn_id| { expense_id: txn_id, payment_id: payment.id } })

      payment
    end
  rescue ActiveRecord::RecordNotUnique
    { message: 'Transaction/s already paid!' }
  end

  private_class_method def self.only_one_bank?(txn_ids)
    sql = Txn.select('(CASE WHEN MIN(wallet_id) = MAX(wallet_id) THEN TRUE ELSE FALSE END) AS only_one_bank')
             .where({ id: txn_ids })
             .to_sql

    ActiveRecord::Base.connection.exec_query(sql).to_a.first['only_one_bank']
  end

  private_class_method def self.not_a_credit_expense(txn_ids)
    sql = Txn.select('wallets.direction AS wallet_direction').joins('LEFT JOIN wallets ON wallets.id = txns.wallet_id')
             .where({ id: txn_ids.first })
             .to_sql

    ActiveRecord::Base.connection.exec_query(sql).to_a.first['wallet_direction'] != 0
  end
end
