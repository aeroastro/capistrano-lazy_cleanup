require "capistrano/lazy_cleanup/version"
require "capistrano/lazy_cleanup/defaults"

module Capistrano
  module LazyCleanup
  end
end

load File.expand_path("../tasks/lazy_cleanup.rake", __FILE__)
