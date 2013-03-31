require 'rake/testtask'
Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].each { |ext| load ext }

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
  t.ruby_opts = ['-rubygems'] if defined? Gem
  t.ruby_opts << '-I.'
  #t.pattern = "spec/*_spect.rb"
end

desc "Load this app in a console"
task :console do
  sh "irb -r ./app.rb"
end
