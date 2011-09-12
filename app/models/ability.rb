class Ability
  include CanCan::Ability

  def initialize(profile)

	#Provide the aliases for the actions here	
	alias_action :index, :show, :to => :read
	alias_action :new, :to => :create
	alias_action :edit, :to => :update
	alias_action :smsnew, :sms, :emailnew, :email, :to => :communicate
	
	#for the super user
	if profile.has_role?('super_user')
  		can :manage, :all
  	end
  	
  	#Authorization rules for the Student
  	
  	if profile.profile_type == Profile::PROFILE_TYPE_STUDENT
  		
  		# USER OR MODERATOR OR ADMIN
  		# 1. can :read the student infomation in his own class (not just section)
  		# 2. can :update his own information
  		
  		if profile.has_any_role? ( %w{user moderator admin} ) # This will be converted to string array
  		  	can :read, Student do student
  		  		profile.section.clazz = student.section.clazz
  		  	end
  			can :update, Student do |student|
  				profile.user_profile == student
  			end 
  		end
  		
  		#GUEST
  		# 1. can just :read the students in his own clazz
  		if profile.has_role?('guest')
  			can :read, Student do student
  		  		profile.section.clazz = student.section.clazz
  		  	end
  		end			
  	end
  		
	if profile.profile_type == Profile::PROFILE_TYPE_TEACHER
		
		# ADMIN
		# 1. can :manage the students who are in the same branch as he is
		# 2. can :manage the teachers and students who are in the same branch as he/she is.
		if profile.has_role?('admin')
  			can :manage, Student do |student|
  				profile.user_profile.branch == student.section.clazz.branch	
  			end
			can :manage, Teacher do |teacher|
  				profile.user_profile.branch == teacher.branch	
  			end
  			can :manage, Clazz do |clazz|
  				profile.user_profile.branch.clazzs.include?(clazz)
  			end
  				
		end
  		
		#MODERATOR
		# 1. can :manage the students to whom he is a class teacher
		# 2. can :manage (except :destroy) the teachers who are in the same branch as he is
		if profile.has_role?('moderator')
			can :manage, Student do |student|
				student.class_teacher?(profile.user_profile)
			end
			can :manage, Teacher do |teacher|
				profile.branch == teacher.branch
			end
			cannot :destroy, Teacher			
		end		
				
		# USER
		# 1. can :manage (except :destroy) the students who are in the same branch as  he is
		# 2. can :read all the teachers who are in the same branch
		# 3. can :update his own profile
		if profile.has_role?('user')
			can :update, Student do |student|
				student.class_teacher?(profile.user_profile)
			end
			can :read, Student do |student|
				profile.user_profile.branch == student.section.clazz.branch
			end
			cannot :destroy, Student
  		  	can :read, Teacher do |teacher|
				profile.user_profile.branch == teacher.branch	
			end  		  		
  			can :update, Teacher do |teacher|
  				profile.user_profile == teacher
  			end			
		end
		
		#'GUEST
		# can just :read the students to whom he is the class teacher
		# can :read the teachers who are in the same branch
		if profile.has_role?('guest')
			can :read, Student do |student|
				student.class_teacher?(profile.user_profile)
			end
			can :read, Teacher do |teacher|
				profile.user_profile.branch == teacher.branch	
			end
		end			
		
  	end # end of profile.profile_type == Profile::PROFILE_TYPE_TEACHER
  	
  	if profile.profile_type == Profile::PROFILE_TYPE_ADMIN
  	end
  	
  	
  	
  	
	#Authorization rules for the Branch
  	if profile.has_role?('admin')
  		can :manage, Branch
  		cannot :destroy, Branch
  	end
  	if profile.has_role?('moderator')
  		can :read, Branch
  	end
  	if profile.has_role?('guest')
		can :read, Branch do |branch|
			#this has to be made generic for all the record types
	 		profile.user_profile.branch == branch
		end
  	end
  	
  	#Authorization rules for the branches

  		
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
  
end
