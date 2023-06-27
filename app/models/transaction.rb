# frozen_string_literal: true

class Transaction < ApplicationRecord
  has_one :wallet
  has_one :purpose
  # has_and_belongs_to_many :tags

  enum :category, %i[need want]
  enum :direction, %i[debit credit]
end
