
require 'DataFrame'

def pr s
  print s unless not ENV['QUIET'].nil?
end

namespace :util do
  task :get_people do
    filename = 'PatrolRoster07-08CPR.csv'
    filename = ENV['FILENAME'] if not ENV['FILENAME'].nil?
    @f = DataFrame.new filename, { 'expect_header' => 1 }
  end

  desc "Load and print the People roster .csv to check syntax"
  task :check_people => [:get_people] do
    p @f
  end

  desc "Verify no People have Session assignments"
  task :check_no_assignments => :environment do
    collection = Person.find :all, :conditions => "session_id not null"
    if collection.size == 0
      pr "No people have assignments, continuing\n"
    else
      pr "#{collection.size} people have assignments, ABORTING\n"
      abort
    end
  end

  desc "Wipe out all People from db"
  task :wipe_People => [ :environment, :check_no_assignments ] do
    pr "Wiped out all #{Person.delete_all} People\n"
  end

  desc "Stuff .csv info into db, wiping it first"
  task :load_people => [ :environment, :get_people, :wipe_People ] do
    for i in 0..(@f.rows.size-1)
      if @f[i,'CPR'] != ''
        name = [@f[i,'FIRST'], @f[i,'LAST']].join(' ').strip
        email = @f[i,'email'].strip
        phone = [@f[i,'Area'], @f[i,'Phone']].join(' ').strip
        Person.create(:name => name, :email => email, :phone => phone)
        pr '.'; STDOUT.flush
      end
    end
    collection = Person.find :all
    pr "\nLoaded #{collection.size} People\n"
  end
end

