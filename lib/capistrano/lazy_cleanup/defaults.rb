require 'rake'

module Capistrano
  module LazyCleanup
    module Defaults
    end
  end
end

# TODO: If Capistrano::Plugin system becomes stable, refactor these code.

Rake::Task.define_task('load:defaults') do
  set_if_empty(:lazy_cleanup_old_releases_path_template, "#{fetch(:tmp_dir, '/tmp')}/capistrano-lazy_cleanup_old_releases.XXXXXXXXXX")
end
