require './app'

namespace :db do
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, "db/migrations")
  end  
end
