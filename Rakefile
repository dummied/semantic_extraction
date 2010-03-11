require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "semantic_extraction"
    gem.summary = %Q{Extract meaningful information from unstructured text with Ruby}
    gem.description = %Q{Using a variety of APIs (Yahoo term Extractor and Alchemy are currently supported), semantic_extraction can automatically return a collection of keywords for an arbitrary block of text. If using Alchemy, it can also return named entities.}
    gem.email = "chris@chrisvannoy.com"
    gem.homepage = "http://github.com/dummied/semantic_extraction"
    gem.authors = ["Chris Vannoy"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.add_dependency "ruby_tubesday"
    gem.add_dependency "nokogiri"
    gem.add_dependency "extlib"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "semantic_extraction #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
