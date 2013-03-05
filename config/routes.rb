Smmoney::Application.routes.draw do



  get "transfers/new"

  get "balances/new"

scope '/sm' do

  match "ussd.xml"    => "landing_pages#loginxml", :as => :login
  match "login.xml"    => "landing_pages#loginxml", :as => :login
  match "index.xml"    => "landing_pages#new", :as => :landing_pages
  match "balance.xml"    => "landing_pages#balance", :as => :landing_pages_balance
  match "transfer.xml"    => "landing_pages#transfer", :as => :transfers
  match "cashin.xml"    => "landing_pages#cashin", :as => :cashin
  match "cashout.xml"    => "landing_pages#cashout", :as => :cashout
  match "password.xml"    => "landing_pages#password", :as => :password
  match "change_password.xml"    => "landing_pages#change_password", :as => :change_password

  match "signup"   => "users#new",    :as => :signup
  match "login"    => "sessions#new", :as => :login


  match "amount.xml"    => "transfers#amount", :as => :transfers_amount
  match "logout"   => "sessions#destroy", :as => "logout"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match 'admin'        => 'admin#index',              :as => :admin
  match 'admin/users'  => 'admin#users',              :as => :admin_users
  match 'admin/transactions' => 'admin#transactions', :as => :admin_transactions
  match 'admin/issue_emoney'  => 'admin#issue_emoney',              :as => :admin_issue_emoney
  match 'admin/cancel_emoney'  => 'admin#cancel_emoney',              :as => :admin_cancel_emoney
  match 'admin/status'  => 'admin#status',              :as => :admin_status
  match 'admin/login'  => 'admin#login',              :as => :admin_login
  
  match 'transactions' => 'transactions#index', :as => :transactions
  match 'balance'      => 'transactions#balance', :as => :balance
  match 'transfer'     => 'transactions#transfer',:as => :transfer
  match 'transactions/messages' => 'transactions#messages', :as => :transaction_messages
  match 'users/:user_id/user_phones/:phone_id' => 'user_phones#destroy', :as => :transaction_messages
  
  resources :users do
    member do
      post 'delete'
      get 'delete'
      #post 'user_phones'
    end
    resources :user_phones
  end
  
  resources :sessions do
    collection do
      post 'create_admin'
      get 'error_message'
      #get 'unregistered_number'
      #get 'incorrect_credentials'
    end
  end
  
  resources :transactions do
    collection do
      post 'search'
      get 'search'
    end
  end
  
  resources :interfaces do
    member do
      post 'delete'
    end
  end

  resources :countries do
    member do
      post 'delete'
    end
  end
  
  resources :companies do
    member do
      post 'delete'
    end
  end
 
  resources :accounts do
    member do
      post 'delete'
    end
  end

  resources :languages do
    member do
      post 'delete'
    end
  end

  
    resources :roles do
    member do
      post 'delete'
    end
  end

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'transactions#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
end
