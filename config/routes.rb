Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root :to => 'slack#top'
  get '/top' =>  'slack#top'
  post '/top' => 'slack#slackmessage'
end