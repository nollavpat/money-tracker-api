# frozen_string_literal: true

class TagTxn < ApplicationRecord
  belongs_to :tag
  belongs_to :txn
end
