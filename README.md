<img src="https://apiuat.shieldpay.com/images/img-shieldpay-logo-color.svg" width="300">

# ShieldPay Ruby gem

User the ShieldPay api using this gem.

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

### ShieldPay::Customer
Create a customer using ShieldPay::Customer.create e.g.

```ruby
customer = ShieldPay::Customer.create(display_name: "Dave Bananas", email: "dave@bananas.com", mobile_no: "555 12345")
#=> creates a customer in the ShieldPay database - returning the customer_key
```

#### Attributes
`display_name` The customer's name
`email` Their email
`mobile_no` ...and their mobile
`customer_key` After creating the customer there's a customer key that should be stored in your database for working with ShieldPay.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shieldpay.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

