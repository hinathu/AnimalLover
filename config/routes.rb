Rails.application.routes.draw do

# ゲストログイン機能
devise_scope :customer do
  post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in'
  # delete 'customers/guest_sign_out', to: 'public/sessions#destroy_all', as: 'destroy_all_guest_sign_out'
end

# 顧客用
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

# 管理者側のルーティング設定
  namespace :admin do
    
    # customers
    resources :customers, only: [:index, :show, :edit, :update]

    # genres
    resources :genres, only: [:index, :create, :edit, :update, :destroy]

    #items
    resources :items, only: [:index, :show, :edit, :update, :destroy] do
      
      # comments
      resources :comments, only: [:destroy]
      
      # 検索機能
      collection do
        get 'search'
      end
    end

  end

  # 会員側のルーティング設定
  scope module: :public do

    # customers
    resources :customers, only: [:index, :show, :edit, :update] do
      member do 
        get :favorites
      end
    end
    
    # 退会確認用
    get 'customers/:id/unsubscribe' => 'customers#unsubscribe', as: 'unsubscribe'
    # 論理削除用のルーティング
    patch 'customers/:id/withdrawal' => 'customers#withdrawal', as: 'withdrawal'
   
    # items
    resources :items, only: [:new, :create, :show, :edit, :update, :index, :destroy] do
    
      # favorites
      resource :favorites, only: [:create, :destroy]
  
      # comments
      resources :comments, only: [:create, :destroy]
      
      # 検索機能
      collection do
        get 'search'
      end
    end 
    
    root to: "homes#top", as: "top"
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
