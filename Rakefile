namespace :assets do
  namespace :compile do
    task :default => ["css:compile:default", "js:compile:default"]
    task :prod => ["css:compile:prod", "js:compile:default"]
    task :clear => ["css:clear", "js:clear"]
  end

  namespace :css do
    task :clear do
      puts "*** Removing compiled CSS ***"
      system "rm -vf public/assets/*.css"
    end

    namespace :compile do
      task :default => :clear do
        puts "*** Compiling CSS ***"
        system "compass compile"
      end

      task :prod => :clear do
        puts "*** Compiling CSS ***"
        system "compass compile --output-style compressed --force"
      end
    end
  end

  namespace :js do
    task :clear do
      puts "*** Removing compiled JS ***"
      system "rm -vf public/assets/*.js"
    end

    namespace :compile do
      task :default => :clear do
        system "cp assets/js/main.js public/assets/main.js"
      end
    end
  end
end

desc "Compile assets for production"
task :default => ["assets:compile:prod"]

desc "Compile assets for development"
task :development => ["assets:compile:default"]

# assets:precompile is automatically executed by Heroku's build process
task "assets:precompile" => [:default]