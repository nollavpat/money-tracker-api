# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :tag_txns
  has_many :txns, through: :tag_txns
end
