require "capistrano/lazy_cleanup/version"

module Capistrano
  module LazyCleanup
  end
end

load File.expand_path("../tasks/lazy_cleanup.rake", __FILE__)
