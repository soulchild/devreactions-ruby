namespace :assets do
  desc "Remove compiled CSS"
  task :clear => ["compile:clear"]

  desc "Compile CSS"
  task :compile => ["compile:default"]

  namespace :compile do
    task :clear do
      puts "*** Clearing CSS ***"
      system "rm -Rfv public/assets/*"
    end

    task :default => :clear do
      puts "*** Compiling CSS ***"
      system "compass compile"
    end

    desc "Compile CSS for production"
    task :prod => :clear do
      puts "*** Compiling CSS ***"
      system "compass compile --output-style compressed --force"
    end
  end
end

# assets:precompile is automatically executed by Heroku's build process
task "assets:precompile" => ["assets:compile:prod"]
