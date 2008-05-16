#!/usr/bin/env ruby

# from http://errtheblog.com/posts/89-huba-huba
require 'rubygems'
unless ARGV[0]
  puts "Here are your configs: #{Dir["*"].join(',')}"
  puts "usage: #{$0} CONFIG"
  exit
end

home = File.expand_path('~')

Dir["#{ARGV[0]}/*"].each do |file|
  target = File.join(home, ".#{File.split(file)[-1]}")
  `ln -f -h -s -i #{File.expand_path file} #{target}` # we need all these options (f and h) in order to prevent looped symlinks for dotdirectories
end

# git push on commit
`echo 'git push' > .git/hooks/post-commit`
`chmod 755 .git/hooks/post-commit`