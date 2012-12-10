RedmineApp::Application.routes.draw do
  resources :auto_fields
  resources :hidden_fields
  resources :disabled_fields
  resources :required_fields
  resources :tracker_roles
end
