class Ability
  	include CanCan::Ability

=begin
	1. super_user - can perform any action on the entire application. He can create and update instititutions
	
	2. admin - can perform any action on a institution to which he belongs to. He can create and update branches in a particular institution
	
	3. moderator - can perform any action on the components of a branch (teacher, student, section, clazz) etc.
	
	4. teacher
	
	5. student
	
	6. guest
	
	7. user	
=end
	
	# Note that the 'create' action has not been used anywhere as of now. See whether we need the action in future
	
	def initialize(profile)
	#Provide the aliases for the actions here	
		alias_action :index, :show, :actions_box, :to => :read
		alias_action :new, :to => :create
		alias_action :edit, :to => :update
		alias_action :smsnew, :sms, :emailnew, :email, :to => :communicate
		alias_action :stunew, :stucreate, :to => :update_section_elements
		alias_action :secnew, :seccreate, :to => :update_clazz_elements
		alias_action :subnew, :subcreate, :clznew, :clzcreate, :testnew, :testcreate, :tchrnew, :tchrcreate, :to => :update_branch_elements
		alias_action :branchnew, :branchcreate, :to => :update_institution_elements
		@profile = profile
		@profile ||= Profile.new
		@profile.roles.each { |role| send(role.name) }
	end
		
	def super_user
  		can :manage, :all
  	end
  	

	# Role - admin
	def admin
		can :manage, Student do |student|
			@profile.user_profile.branch.institution == student.section.clazz.branch.institution
		end
		can :manage, Teacher do |teacher|
			@profile.user_profile.branch.institution == teacher.branch.institution
		end
		can :manage, Section do |section|
			@profile.user_profile.branch.institution == section.clazzbranch.institution
		end
		can :manage, Clazz do |clazz|
			@profile.user_profile.branch.institution == clazz.branch.institution
		end
		can :manage, Branch do |branch|
			@profile.user_profile.branch.institution == branch.institution
		end
		can [:update_institution_elements, :update, :read], Institution do |institution|
			@profile.user_profile.branch.institution == institution
		end
		can :index, Institution
	end
  		
	#Role - moderator
	def moderator
		teacher
		can :manage, Student do |student|
			student.section.clazz.branch == @profile.user_profile.branch
		end
		can :manage, Teacher do |teacher|
			@profile.user_profile.branch == teacher.branch
		end
		can :manage, Section do |section|
			@profile.user_profile.branch == section.clazz.branch
		end
		can :manage, Clazz do |clazz|
			@profile.user_profile.branch == clazz.branch
		end
		can [:update_branch_elements, :update], Branch do |branch|
			@profile.user_profile.branch == branch
		end
		can :index, Branch
		
	end		
				
	# Role - teacher
	def teacher
		guest
		can :manage, Student do |student|
			student.class_teacher?(@profile.user_profile)
		end
		can :update, Teacher do |teacher|
			@profile.user_profile == teacher
		end
		can [:update, :update_section_elements], Section do |section|
			section.class_teacher_id == @profile.id
		end
		can :index, Section
	end

	# Role - student
	def student
		guest
		can :update, Student do |student|
			@profile.user_profile == student
		end 
	end
  				
	#Role - guest
	def guest
		if @profile.profile_type == Profile::PROFILE_TYPE_STUDENT
			can :read, Student do |student|
				@profile.user_profile.section.clazz == student.section.clazz
			end
		end
		
		if @profile.profile_type == Profile::PROFILE_TYPE_TEACHER
			can :read, Student do |student|
				@profile.user_profile.branch.clazzs.include?student.section.clazz
			end
			can :read, Teacher do |teacher|
				@profile.user_profile.branch == teacher.branch	
			end
		end
	end			
	
	def user
		#each of the roles in the role table should have a definition here
	end
	
	
		
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
