Gem::Specification.new do |s|
  s.name        = 'schedule_zg'
  s.version     = '1.0.0'
  s.date        = '2016-04-10'
  s.summary     = 'Schedule'
  s.description = 'Scheduler for excercise 2'
  s.authors     = ['Zach Goldman']
  s.email       = 'zggoldman@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.executables << 'schedule_zg'
  s.homepage    = ''
  s.license     = ''


  s.add_development_dependency 'rspec', '~> 3.4'
end

