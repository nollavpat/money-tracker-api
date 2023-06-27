# frozen_string_literal: true

class Txn < ApplicationRecord
  has_one :wallet
  has_one :purpose
  has_many :tag_txns
  has_many :tags, through: :tag_txns

  enum :category, %i[need want]
  enum :direction, %i[debit credit]
end
