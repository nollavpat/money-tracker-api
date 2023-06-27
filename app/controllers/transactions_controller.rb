# frozen_string_literal: true

# Transactions controller
class TransactionsController < ApplicationController
  before_action :authenticate_token

  def create
    render plain: "I'm only accessible if you know the password"
  end

  def index
    render plain: 'Everyone can see me!'
  end
end
