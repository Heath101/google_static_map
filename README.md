# GoogleStaticMap


This gem is a quick implementation of the algorithm specified by Google in order to authenticate API calls to Google's Static Maps API.

In order to use Google Static Maps API with a Premium Plan, Google requires that you include a **client id** and **signature** for authentication.  This gem implements the digital signing algorithm specified by Google's documentation [Google Static Maps API Documentation](https://developers.google.com/maps/documentation/static-maps/get-api-key#client-id).



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google_static_map'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google_static_map

## Usage


To create a signed url, create a `GoogleStaticMaps::SignedURL` by passing in the desired url (with all query parameters you would normally pass to the Static Maps API) and your Premium Plan api key.  The url must contain your `client` parameter.  If you are migrating from using just a plain `key` (*the alternate way of authenticating an api*) in the url, you must make sure to remove it or else the API call will fail authentication.

```ruby
url = 'https://www.example.com?client=gme-yourcompany'
signed_url = GoogleStaticMaps::SignedURL.new(url,'your_google_api_key')

signed_url.to_s #=> "https://www.example.com?client=gme-yourcompany&signature=yXfNZ_fDBaOPoZ6wN4_bHNr8Hvc=\n"
```

### Middleware

Also included in this gem is a Rack middleware, which provides a convenient proxy to the Google Static Maps API.  This allows you to just make static map api calls to your own endpoint which will take care of adding the `client` parameter and signing the request before redirecting to the Google Static Maps API endpoint.

By default the middleware will capture all calls made to `/google-static-map`, and relies on the presence of 2 environment variables:

`GOOGLE_MAPS_API_KEY` your Premium Plan api key.

`GOOGLE_MAPS_CLIENT` your Premium Plan client id.

To use the middleware, add it to your `config.ru` file:

```ruby
# Sample config.ru file from a Rails App

require ::File.expand_path('../config/environment',  __FILE__)
require 'google_static_map/middleware'

use GoogleStaticMap::Middleware
run Rails.application

```

Then in your code you can just make calls to your endpoint with desired query parameters, and they will get redirected automatically.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/google_static_map. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
