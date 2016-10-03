#eSignLive Client

[![Gem Version](https://d25lcipzij17d.cloudfront.net/badge.svg?id=rb&type=6&v=0.1.3&x2=0)](https://badge.fury.io/rb/esignlive)
[![Build Status](https://travis-ci.org/bjacobson26/esignlive.svg?branch=master)](https://travis-ci.org/bjacobson26/esignlive)
[![Code Climate](https://codeclimate.com/github/bjacobson26/esignlive/badges/gpa.svg)](https://codeclimate.com/github/bjacobson26/esignlive)
## Usage

###Create a client

```ruby
client = ESignLive::Client.new(api_key: your_api_key, environment: 'sandbox')
```

For production:

```ruby
client = ESignLive::Client.new(api_key: your_api_key, environment: 'production')
```


###Make some API calls

#####Get all packages in your account
```ruby
packages = client.get_packages
```

#####Get a package:
```ruby
package = client.get_package(package_id: your_package_id)
```
#####API Calls
- authentication_token(package_id:)
- sender_authentication_token(package_id:)
- signer_authentication_token(signer_id:,package_id:)
- get_packages
- get_package(package_id:)
- get_signing_status(package_id:)
- get_document(package_id: document_id:, pdf: false)
- get_roles(package_id)
- update_role_signer(package_id:, role_id:, email:, first_name:, last_name:)
- create_package(opts={})
- create_package_from_template(template_id:, opts: {})
- send_package(package_id:)
- signing_url(package_id:, role_id:)
- remove_document_from_package(document_id:, package_id:)

## Installation
Add this line to your application's Gemfile:

```ruby
  gem 'esignlive'
```

  And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install esignlive
```

## Contributing
####Submit a pull request

1. Fork the repo.

2. Push to your fork and submit a pull request.


####Syntax:

 - Two spaces, no tabs.
 - No trailing whitespace. Blank lines should not have any space.
 - Prefer &&, || over and, or.
 - MyClass.my_method(my_arg) not my_method( my_arg ) or my_method my_arg.
 - a = b and not a=b.
 - Follow the conventions you see used in the source already.


##TODO
 - More API calls
 - Tests

## License
  The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
