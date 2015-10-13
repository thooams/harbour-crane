#Rake::Task["setup:nginx"].execute
require 'rake'
Rake::Task["lib/tasks/nginx"].execute
