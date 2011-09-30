WhiteReports::Application.routes.draw do
   
  	get "log_out" => "sessions#destroy", :as => "log_out"
	get "log_in" => "sessions#new", :as => "log_in"
	get "sign_up" => "profiles#new", :as => "sign_up"
	
	resources :institutions do
		get 'branchnew', :on => :member
		put 'branchcreate', :on => :member
		get 'actions_box', :on => :member		
	end
		
	resources :branches do
		get 'tchrnew', :on => :member
		put 'tchrcreate', :on => :member
		
		get 'clznew', :on => :member
		put 'clzcreate', :on => :member	  
		
		get 'subnew', :on => :member
		put 'subcreate', :on => :member	  	  
		
		get 'testnew', :on => :member
		put 'testcreate', :on => :member	 
		get 'actions_box', :on => :member		
	end
	
	#resources :schools do
		#get 'tnew', :on => :member
		#put 'tcreate', :on => :member
		
		#get 'secnew', :on => :member
		#put 'seccreate', :on => :member	  
		
		#get 'subnew', :on => :member
		#put 'subcreate', :on => :member	  	  
		
		#get 'testnew', :on => :member
		#put 'testcreate', :on => :member	 
	#end
	
	resources :sections do
		get 'stunew', :on => :member
		put 'stucreate', :on => :member
		get 'emailnew', :on => :member
		post 'email', :on => :member			
		get 'marknew', :on => :member
		post 'markcreate', :on => :member		
		get 'actions_box', :on => :member			
	end
	
	resources :clazzs do
		get 'secnew', :on => :member
		put 'seccreate', :on => :member
		get 'emailnew', :on => :member
		post 'email', :on => :member		
		get 'actions_box', :on => :member				
	end	
	
	resources :students do
		get 'emailnew', :on => :member
		post 'email', :on => :member
		get 'smsnew', :on => :member
		post 'sms', :on => :member
		get 'actions_box', :on => :member
	end
	
	resources :teachers do
		get 'emailnew', :on => :member
		post 'email', :on => :member	
		get 'smsnew', :on => :member
		post 'sms', :on => :member	
		get 'actions_box', :on => :member					
	end
	
	resources :marks do
		get "section_dyn_vals", :on => :collection
		get "cols_and_spline", :on => :collection
		get "stacked_cols", :on => :collection	
		get "table_cols", :on => :collection
		get "negative_stack", :on => :collection
		get "section_any1_graphs", :on => :collection			
		get "section_range_graphs", :on => :collection	
		get "section_total_graphs", :on => :collection
		get "student_total_graphs"	, :on => :collection
		get "student_master_graphs", :on => :collection			
	end
	
	resources :subjects
	resources :tests
	resources :profiles
	resources :sessions
	resources :password_resets
		
	root :to => "profiles#index"	
	
end
