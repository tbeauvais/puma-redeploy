# Puma Redeploy

The puma-redeploy gem is a puma plugin that allows you to redeploy a new version of your Ruby application in a container without a full container deploy. 

Key Points:
* Encourages the separation of the build process from deployment
* Runtime container does not include application code
* Leverages Puma [phased-restart](https://github.com/puma/puma/blob/master/docs/restart.md#phased-restart) to ensure uptime deploy
* Deploys in seconds
* Pluggable handlers to detect redeploy (File, S3, Artifactory, etc..)

**Note** - Currently there are File and S3 handlers for loading archives.

![image](https://user-images.githubusercontent.com/121275/219976698-80575b17-17b7-4861-8c10-675f3f615e25.png)


Example application can be found [here](https://github.com/tbeauvais/puma-redeploy-test-app)

Also see the [sidekiq-redeploy](https://github.com/tbeauvais/sidekiq-redeploy) gem.

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

# Specify the redeploy watch file from an environment variable. This can a file system location or S3 URL. For example `/app/pkg/watch.me` or `s3://puma-test-app-archives/watch.me`.
redeploy_watch_file ENV['WATCH_FILE']


# Specify the number of seconds between checking watch file. Defaults to 30.
redeploy_watch_delay 15

```

The watch file can contain an optional list of commands to run and the required archive_location. The archive_location can be a file path or S3 URL
For example when using a file:
```yaml
---
commands:
  - bundle 
archive_location: /app/pkg/test_app_0.0.3.zip
```

For example when using S3:
```yaml
---
commands:
  - bundle 
archive_location: s3://puma-test-app-archives/test_app_0.0.3.zip
```


### Archive Loader
The `archive-loader` is a cli used to fetch and deploy the application archive prior to starting the puma server. This is useful when the application code does not exist in the runtime container.

```shell
archive-loader
Usage: archive-loader [options]. Used to load the archive prior to starting the puma app server.
    -a, --app-dir=DIR                [Required] Location of application directory within the container.
    -w, --watch=WATCH                [Required] Location of watch file (file or s3 location).
    -h, --help                       Prints this help
```

For example this will fetch and unzip the application archive and then start puma.
```shell
archive-loader -a /app -w /app/pkg/watch.yml && bundle exec puma -C config/puma.rb
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
