# frozen_string_literal: true

class Wallet < ApplicationRecord
  enum :direction, %i[credit debit]
end
