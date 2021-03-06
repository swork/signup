
require 'DataFrame'

namespace :util do

  def pr s
    print s unless not ENV['QUIET'].nil?
  end

  def get_frame filename
    DataFrame.new filename, { 'expect_header' => 1 }
  end

  def get_people_csv
    filename = 'PatrolRosterCPR.csv'
    filename = ENV['FILENAME'] if not ENV['FILENAME'].nil?
    get_frame filename
  end

  def get_sessions_csv
    filename = 'PatrolCPRSessionsA.csv'
    filename = ENV['FILENAME'] if not ENV['FILENAME'].nil?
    get_frame filename
  end

  desc "Load and print the People roster .csv to check syntax"
  task :check_people do
    people = get_people_csv
    p people
  end

  desc "Load and print Sessions .csv to check syntax"
  task :check_sessions do
    sessions = get_sessions_csv
    p sessions
  end

  desc "Count people assigned to sessions"
  task :count_assignments => :environment do
    @assigned_people = Person.find :all, :conditions => "session_id not null"
    pr "#{@assigned_people.size} people have assignments\n"
  end

  desc "Verify no People have Session assignments"
  task :check_no_assignments => :count_assignments do
    if @assigned_people.size == 0
      pr "No people have assignments, continuing\n"
    else
      pr "Some people have assignments, ABORTING\n"
      abort
    end
  end

  desc "Wipe out all People from db"
  task :wipe_People => [ :environment, :check_no_assignments ] do
    pr "Wiped out all #{Person.delete_all} People\n"
  end

  desc "Wipe out all Sessions from db"
  task :wipe_Sessions => [ :environment, :check_no_assignments ] do
    pr "Wiped out all #{Session.delete_all} Sessions\n"
  end

  desc "Stuff People .csv info into db, wiping it first"
  task :load_people => [ :environment, :wipe_People ] do
    people = get_people_csv
    for i in 0..(people.rows.size-1)
      if people[i,'CPR'] != ''
        name = [people[i,'FIRST'], people[i,'LAST']].join(' ').strip
        email = people[i,'email'].strip
        phone = [people[i,'Area'], people[i,'Phone']].join(' ').strip
        Person.create(:name => name, :email => email, :phone => phone)
        pr '.'; STDOUT.flush
      end
    end
    collection = Person.find :all
    pr "\nLoaded #{collection.size} People\n"
  end

  desc "Stuff Sessions .csv info into db, wiping it first"
  task :load_sessions => [ :environment, :wipe_Sessions ] do
    sessions = get_sessions_csv
    for i in 0..(sessions.rows.size-1)
      name = sessions[i,'name'].strip
      limit = sessions[i,'limit']
      Session.create(:name => name, :max_attendees => limit)
      pr '.'; STDOUT.flush
    end
    collection = Session.find :all
    pr "\nLoaded #{collection.size} Sessions\n"
  end
end

