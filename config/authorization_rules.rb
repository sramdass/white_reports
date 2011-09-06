authorization do
  role :admin do
    has_permission_on :institutions, :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  role :guest do
    has_permission_on :articles, :to => [:index, :show]
    has_permission_on :comments, :to => [:new, :create]
    has_permission_on :comments, :to => [:edit, :update] do
      if_attribute :user => is { user }
    end
  end
  
  role :student do
    includes :guest
    has_permission_on :comments, :to => [:edit, :update]
  end
  
  role :teacher do
    includes :guest
    has_permission_on :articles, :to => [:new, :create]
    has_permission_on :articles, :to => [:edit, :update] do
      if_attribute :user => is { user }
    end
  end
end
