require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
  t.ruby_opts = ['-rubygems'] if defined? Gem
  t.ruby_opts << '-I.'
  #t.pattern = "spec/*_spect.rb"
end

task :console do
  sh "irb -r ./app.rb"
end
