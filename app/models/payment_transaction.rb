# frozen_string_literal: true

class PaymentTransaction < ApplicationRecord
  belongs_to :payment
  belongs_to :expense
end
