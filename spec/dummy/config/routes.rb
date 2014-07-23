Dummy::Application.routes.draw do
  resources :users do
    get :new_recursive, on: :collection
    post :post_recursive, on: :collection
  end
end
