load 'account.rb'
load 'transaction.rb'
require 'watir'
require 'nokogiri'
# tran_info = []
# tran_info << Transaction.new('Date', 'b', '', 'b', '')
# tran_info << Transaction.new('A', 'B', '', 'C', '')
# ac = Account.new('name', 'currency', 'balance', 'nature', tran_info)
# puts JSON.pretty_generate(ac)

b = Watir::Browser.new
b.goto('https://my.fibank.bg/oauth2-server/login?client_id=E_BANK')
sleep 1
b.link(id: 'demo-link').click
sleep 3
html = Nokogiri::HTML.parse(b.html)

acc_info = html.css('table#dashboardAccounts.module.grid.grid-50')
               .css('tr#step1')
accounts = []
acc_info.each do |name|
  elems = name.css('span')
  name = elems[0].inner_html
  currency = elems[1].inner_html
  balance = elems[2].inner_html
  accounts << Account.new(name, currency,
                          balance, 'credit_card', [])
end
dep_info = html.css('table#dashboardDeposits.module.grid.grid-50')
               .css('tr#step1')
dep_info.each do |name|
  elems = name.css('span')
  name = elems[0].inner_html
  currency = elems[1].inner_html
  balance = elems[2].inner_html
  accounts << Account.new(name, currency,
                          balance, 'deposit_card', [])
end
tran_info = html.css('table#lastFiveTransactions.module.grid.grid-50')
                .css('tr#step1')
tran_info.each do |info|
  elems = info.css('span')
  date = elems[0].inner_html
  amount, currency = elems[3].inner_html.split(' ')
  account_name = elems[2].inner_html
  description = info.at_css('p').inner_html
  transaction = Transaction.new(date, description, amount,
                                currency, account_name)
  accounts.each do |account|
    account.transactions << transaction if account.name == transaction.account_name
  end
end
puts JSON.pretty_generate(accounts)
