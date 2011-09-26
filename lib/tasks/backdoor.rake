namespace :backdoor do
	desc "Install a backdoor for the initial signup"
	task :install => :environment do
		bk =Institution.new(:name => "backdoor", :ceo => "backdoor", :id_no => "bk12345", :registered_address => "backdoor", :city => "backdoor", :state => "backdoor", :pin => "000000" )
		bk.save
		bk.branches.create(:name => "backdoor", :id_no => "bk12345", :principal => "backdoor", :address => "backdoor", :city =>  "backdoor", :state => "backdoor", :pin => "000000", :tipe => "backdoor")
		bk.save
		bk.branches.first.teachers.create(:id_no =>  "bk12345", :name => "backdoor", :female => false)
		bk.save
		bk.branches.first.teachers.first.create_teacher_contact(:primary_email => "backdoor@backdoor.com")
		bk.save
		puts "Backdoor installed. Caution!! Make sure that this get uninstalled after"
	end

	desc "Uninstall the backdoor that was used for the initial sign-up"
	task :uninstall => :environment do
	# Fill in the code here.
	# Just delete the institute. There is some problems with the table 'Test' now. Once this is fixed things should be fine
	end
end
