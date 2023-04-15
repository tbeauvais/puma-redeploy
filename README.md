# Puma Redeploy

The puma-redeploy gem is a puma plugin that allows you to redeploy a new version of your Ruby application in a container without a full container deploy. 

> **Warning**
> This is a work in progress. The S3 handler support has not yet been implemented. I'm hoping to get to this soon.The [Example application](https://github.com/tbeauvais/puma-redeploy-test-app) currenty used the File handler. 


Key Points:
* Encourages the separation of the build process from deployment
* Leverages Puma [phased-restart](https://github.com/puma/puma/blob/master/docs/restart.md#phased-restart) to ensure uptime deploy
* Deploys in seconds
* Plugable handlers to detect redeploy (File, S3, Artifactory, etc..)


![image](https://user-images.githubusercontent.com/121275/219976698-80575b17-17b7-4861-8c10-675f3f615e25.png)


Example application can be found [here](https://github.com/tbeauvais/puma-redeploy-test-app)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'puma-redeploy'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install puma-redeploy

## Usage

Update your `config/puma.rb` config file with the following
```

# Add the puma-redeploy plugin
plugin :redeploy

# specify the redeploy watch file
redeploy_watch_file './watch_me'

# Specify the number of seconds between checking watch file. Defaults to 30.
redeploy_watch_delay 15

```

The watch file must contain the path to the current archive.
For example:
```
/sinatra_test/pkg/my_application_0.0.1.zip
```

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake spec` to run the tests and `rake rubocop` to check for rubocop offences. 

To install this gem onto your local machine, run the following. **Note** - You must add any new files to git first.

```text
bundle exec rake install
puma-redeploy 0.1.0 built to pkg/puma-redeploy-0.1.0.gem.
puma-redeploy (0.1.0) installed.
```

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/puma-redeploy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/puma-redeploy/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Puma::Redeploy project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/puma-redeploy/blob/master/CODE_OF_CONDUCT.md).
