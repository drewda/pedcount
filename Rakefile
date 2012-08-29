require 'rubygems'
require 'bundler/setup' # because the betabuilder gem is loaded from a git repo
require 'betabuilder'

BetaBuilder::Tasks.new(:ios) do |config|
  config.target = "PedCount"
  config.configuration = "Release"
  config.workspace_path = "project-ios/PedCount.xcworkspace"
  config.scheme = "PedCount Release on Device"
  config.build_dir = "project-ios/build"
  config.xcode4_archive_mode = true

  config.deploy_using(:testflight) do |tf|
    tf.api_token  = "15903fe7b0b3311f3f7775126fdeba7f_NTYyNzg4MjAxMi0wOC0wMiAxMzo0MDowNC4zMjA0MTM"
    tf.team_token = "b247d6f24c4932de65dec92f7466e03b_MTE3MTUzMjAxMi0wOC0xMyAxODo0OTo0OS4yOTAxMzg"
  end
end

namespace :www do
  desc "Build the HTML/CSS/JS from source"
  task :build do
    puts "## Building the Middleman site"
    status = system("middleman build --clean")
    puts status ? "OK" : "FAILED"
  end
end

desc "Build and deploy an iOS build to TestFlight"
task :build_ios_beta => ['www:build', 'ios:build', 'ios:deploy'] do
end