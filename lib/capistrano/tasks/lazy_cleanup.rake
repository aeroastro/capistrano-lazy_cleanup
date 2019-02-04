namespace :capistrano do
  namespace :lazy_cleanup do
    # ref. https://github.com/capistrano/capistrano/blob/v3.11.0/lib/capistrano/tasks/deploy.rake#L148-L194
    desc "Clean up old releases"
    task :cleanup do
      on release_roles :all do |host|
        releases = capture(:ls, "-x", releases_path).split
        valid, invalid = releases.partition { |e| /^\d{14}$/ =~ e }

        warn t(:skip_cleanup, host: host.to_s) if invalid.any?

        if valid.count >= fetch(:keep_releases)
          info t(:keeping_releases, host: host.to_s, keep_releases: fetch(:keep_releases), releases: valid.count)
          directories = (valid - valid.last(fetch(:keep_releases))).map do |release|
            releases_path.join(release).to_s
          end
          if test("[ -d #{current_path} ]")
            current_release = capture(:readlink, current_path).to_s
            if directories.include?(current_release)
              warn t(:wont_delete_current_release, host: host.to_s)
              directories.delete(current_release)
            end
          else
            debug t(:no_current_release, host: host.to_s)
          end
          if directories.any?
            temp_dir = capture(:mktemp, '-d', fetch(:lazy_cleanup_old_releases_path_template))
            execute :mv, *directories, temp_dir
          else
            info t(:no_old_releases, host: host.to_s, keep_releases: fetch(:keep_releases))
          end
        end
      end
    end

    desc "Remove and archive rolled-back release."
    task :cleanup_rollback do
      on release_roles(:all) do
        last_release = capture(:ls, "-xt", releases_path).split.first
        last_release_path = releases_path.join(last_release)
        if test "[ `readlink #{current_path}` != #{last_release_path} ]"
          execute :tar, "-czf",
                  deploy_path.join("rolled-back-release-#{last_release}.tar.gz"),
                  last_release_path
          temp_dir = capture(:mktemp, '-d', fetch(:lazy_cleanup_old_releases_path_template))
          execute :mv, last_release_path, temp_dir
        else
          debug "Last release is the current release, skip cleanup_rollback."
        end
      end
    end
  end
end

Rake::Task['deploy:cleanup'].clear_actions
Rake::Task['deploy:cleanup_rollback'].clear_actions

namespace :deploy do
  task :cleanup do
    invoke "capistrano:lazy_cleanup:cleanup"
  end

  task :cleanup_rollback do
    invoke "capistrano:lazy_cleanup:cleanup_rollback"
  end
end
