require File.expand_path('../config/boot.rb', __FILE__)
require 'padrino-core/cli/rake'

::DataMapper::finalize

namespace :load do
  desc 'Load specific fixture'
  task :fixture, [:filename] => :environment do  |t, args|
    filename = "db/load_#{args[:filename]}.rb"
    load(filename)
  end
end

PadrinoTasks.use(:database)
PadrinoTasks.use(:datamapper)
PadrinoTasks.init

task :default => :test
