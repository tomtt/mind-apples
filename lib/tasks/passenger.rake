namespace :passenger do
  task :restart do
    system("touch tmp/restart.txt")
    system("touch tmp/debug.txt") if ENV["DEBUG"] == 'true'
  end

  task :debug do
    system("touch tmp/restart.txt")
    system("touch tmp/debug.txt")
  end
end
