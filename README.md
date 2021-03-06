# ShieldPay Ruby gem
<img src="https://apiuat.shieldpay.com/images/img-shieldpay-logo-color.svg" width="300">

Connect to the [ShieldPay api](https://www.shieldpay.com) with this gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shieldpay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shieldpay

## Usage

### Configuration
In order to use the ShieldPay api you need to get an organization key from https://www.shieldpay.com.

#### Configuration options
Setting|Description|Optional
-------|-----------|--------
org_key|This is the organization key you need to use the ShieldPay api|No
country_code|2 character country code that is the default for your payments|Yes
debug|Turn debug mode on to see extra messages in your api calls|Yes
default_currency|If you don't set a currency code in your api calls then this is used|Yes
uat|Whether you want to access the uat version of the shieldpay api. Defaults to false|Yes

#### Sample configuration
```Ruby
ShieldPay.configure do |config|
  config.country_code = "GB"
  config.default_currency = "GBP"
  config.org_key = 'XXXYYYZZZ' # this is a pretend org key
end
```
### ShieldPay::Customer
Create a customer using ShieldPay::Customer.create e.g.

```ruby
customer = ShieldPay::Customer.create(display_name: "Dave Bananas",
                                      email: "dave@bananas.com",
                                      mobile_no: "555 12345")
#=> creates a customer in the ShieldPay database - returning the customer_key
```

#### ShieldPay::Customer attributes
Name|Description
----|-----------
`display_name`|The customer's name
`email`|Their email
`mobile_no`|...and their mobile
`customer_key`|After creating the customer, a customer key is generated that should be stored in your database for working with ShieldPay.

### ShieldPay::Company
Create a company to be a ShieldPay user if you know the company's identifier for your region.
```ruby
customer_key = ShieldPay::Company.create(country_code: "GB",
                                     email: "dave@bananas.com",
                                     phone: "555 12345",
                                     identifier: "ABC123")
#=> creates a company in the ShieldPay database - returning the customer_key
```
#### ShieldPay::Company attributes
Name|Description
----|-----------
country_code|The country code for this organization (i.e. GB) Defaults to ShieldPay.configuration.country_code
email|Email address for contact person
identifier|Company number for your region (i.e. Companies House Number)
phone|Contact phone number for company
customer_key|After creating the company a customer key is generated that should be stored in your database for working with ShieldPay.

### ShieldPay::PaymentRequest
Used for requesting payment from the supplier to the buyer.
```ruby
payment_request = ShieldPay::PaymentRequest.create_with_email(from_email: "supplier@bananas.com",
                                                              request_from: "Banana Farms Inc.",
                                                              amount: 100.45,
                                                              currency_code: "GBP",
                                                              description: "20 boxes of bananas",
                                                              to_email: "dave@bananafans.com",
                                                              fee_receiver_amount: 15.50,
                                                              fee_receiver_email: "bill@thebananashop.com")
#=> payment_request now has a payment_request_key to keep track of how the payment request is going.
```

### ShieldPay::Webhook

Used for adding webhook urls for various events.
```ruby
ShieldPay::WebHook.add(url: "https://www.yoursite.com/shieldpay_callback",
                       events: [:initiated, :funds_available])
```

You can get a list of all the current setup webhooks with `.all`.
```ruby
ShieldPay::WebHook.all
#=> this returns a list of webhook objects complete with url, events and id
```

If you want to remove a webhook, use the delete command with the id you returned from the `.all` command.
```ruby
ShieldPay::Webhook.delete("zzzzz-zzzzzzz-zzzzzzz-zzzzzz")
```

Here's a list of the events you can add webhooks for:
```
  initiated
  add_fund
  accepted
  sender_complete
  receiver_complete
  funds_available
  receiver_decline_before_accept
  sender_cancelled_before_funded
  payment_generated
  payment_completed
  funding_pending  
  sender_cancelled_after_funded
  refund_in_progress
  customer_status
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thechrisoshow/shieldpay.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
