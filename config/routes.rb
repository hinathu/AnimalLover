Rails.application.routes.draw do

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
    resources :items, only: [:index, :show, :edit, :update]

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
    end 
    
    root to: "homes#top", as: "top"
    get 'about' => 'homes#about', as: "about"
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
