# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def rand_in_range(from, to)
  rand * (to - from) + from
end

def rand_time(from, to)
  Time.at(rand_in_range(from.to_f, to.to_f))
end


ActiveRecord::Base.transaction do
  # WITH FOREIGN KEYS
  TagTxn.delete_all
  Txn.delete_all
  Purpose.delete_all
  Tag.delete_all
  Wallet.delete_all

  # PURPOSES
  purposes = %w[
    apparel
    bills
    dine_in
    dine_out
    commute
    games
    grocery
    salary
  ]
  
  new_purposes = Purpose.create!(purposes.map { |purpose| { name: purpose } })
  
  puts("Created #{Purpose.count} purposes")
  
  # TAGS
  tags = %w[
    tag1
    tag2
    tag3
  ]
  
  new_tags = Tag.create!(tags.map { |tag| { name: tag } })
  
  puts("Created #{Tag.count} tags")
  
  # WALLETS
  wallets = [
    {
      name: 'gcash',
      balance: 100000,
      logo_url: 'https://yt3.ggpht.com/WWmNjgwcea8lCYzpWOIj0IXXq-PTg-YrRTiRmS38sfj51CV4KLyvjspLNME8xKUm5mzpMpJ1NA=s68-c-k-c0x00ffffff-no-rj'
    },
    {
      name: 'unionbank',
      balance: 100000,
      logo_url: 'https://cdn.yellowmessenger.com/C282ttbyzNtB1630395945901.jpeg'
    },
  ]
  
  new_wallets = Wallet.create!(wallets)
  
  puts("Created #{Wallet.count} wallet")
  
  # TRANSACTIONS
  categories = %w[need want]
  
  # > July
  from = Time.new(2023, 07, 01, 00, 00, 00, "+08:00")
  to = Time.new(2023, 07, 30, 11, 59, 00, "+08:00")
  
  june_transactions = [
    {
      amount: 20000,
      name: 'Sweldo',
      category: 'need',
      wallet_id: new_wallets[1].id,
      purpose_id: new_purposes[7].id,
      created_at: Time.new(2023, 07, 15, 17, 00, 00, "+08:00").gmtime,
      updated_at: Time.new(2023, 07, 15, 17, 00, 00, "+08:00").gmtime
    }
  ]
  
  30.times do
    category = categories.sample
    purpose = new_purposes.slice(0, 7).sample
    wallet = new_wallets.sample
    created_at = rand_time(from, to)
  
    june_transactions.push(
      {
        amount: rand_in_range(-500, -100).to_i,
        name: purpose.name,
        category: category,
        wallet_id: wallet.id,
        purpose_id: purpose.id,
        created_at: created_at.gmtime,
        updated_at: created_at.gmtime
      }
    )
  end
  
  new_transactions = Txn.create!(june_transactions)

  puts("Created #{Txn.count} transactions")

  # TAG TRANSACTIONS
  tag_txns = new_transactions.sample(20).map do |txn|
    { tag_id: new_tags.sample.id, txn_id: txn.id }
  end

  TagTxn.create!(tag_txns)

  puts("Created #{TagTxn.count} tag transactions")
end
