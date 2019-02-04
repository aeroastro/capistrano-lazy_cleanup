# Capistrano::LazyCleanup

This gem makes deployment faster by offloading cleanup I/O for Capistrano 3.x (and 3.x only).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano'
gem 'capistrano-lazy_cleanup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-lazy_cleanup

## Usage

Capfile

```ruby
# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy" # This should be required in advance

# Capfile
require 'capistrano/lazy_cleanup'
```

## Configuration

Capistrano::LazyCleanup can be used out of the box, but you can further customize the configuration at your `deploy.rb`.

```ruby
# Defaults to "#{fetch(:tmp_dir)}/cap-lazy-cleanup-#{fetch(:application)}.XXXXXXXXXX"
set :lazy_cleanup_old_releases_path_template, "/tmp/my-old-releases.XXXXXXXXXX"
```

## What exactly does the `offloading` mean?

On heavy application, it takes time to execute `deploy:cleanup` and `deploy:cleanup_rollback`. This is mainly due to heavy I/O caused by `rm -rf`. The kernel visits and unlink all the directories and files in old release paths. This costs heavy I/O as well as CPU cost.

This gem replaces `rm -rf` with `mktemp` and `mv`. The old release paths are moved to temporary directory. Capistrano and the kernel should handle only the top directory on deployment. After the deployment, files in temporary directory will be eventually cleaned up by low-priorty processes provided by OS.

## Caveats

This gem heavily uses `fetch(:tmp_dir)` as the temporary directory. Therefore, when the combination of deployment size and frequency overwhelms cleanup cycle of your OS, you might encounter disk full issue. You can mitigate this by specifying additional fast cleanup rule on `lazy_cleanup_old_releases_path_template`. (e.g. `tmpwatch -umc 1 /tmp/cap-lazy-cleanup*`)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aeroastro/capistrano-lazy_cleanup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Capistrano::LazyCleanup project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aeroastro/capistrano-lazy_cleanup/blob/master/CODE_OF_CONDUCT.md).
