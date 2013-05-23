# require 'config/environment'
namespace :mms do
  namespace :topical_map do
    desc "Deploys collections to knowledge maps (authenticating through TMB_USER arguments) making the appropriate replacements."  
    task :deploy do |t|
      require File.join(File.dirname(__FILE__), "../lib/knowledge_maps_deployer.rb")
      TopicalMapResource.user = ENV['TMB_USER']
      if !TopicalMapResource.user.blank?
        puts "Password for #{TopicalMapResource.user}:"
        TopicalMapResource.password = STDIN.gets.chomp
        KnowledgeMapsDeployer.do_deployment
      else
        puts 'User and password needed! Use TMB_USER= to set user from command-line.'
      end
    end
  end
end