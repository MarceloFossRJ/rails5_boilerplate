require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'carrierwave'
require 'carrierwave/orm/activerecord'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users,
             controllers: {
                 registrations: "registrations",
                 sessions: "sessions",
                 confirmations: 'confirmations'
             }
  # oAuth callback
  get "/auth/:action/callback", :controller => "authentications", :constraints => { :action => /github|linkedin|google_oauth2/ }
  # creating user via oAuth
  get "/authentications/validate_subdomain/:subdomain"  => "authentications#validate_subdomain"
  # error messages pages
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#server_error", via: :all
  # Application INDEX
  root to: 'homepage#index'
  get 'homepage', to: 'homepage#index', as: :homepage
  get 'confirmation_sent', to: 'confirmation_sent#index' , as: :confirmation_sent
  get 'privacy/index'

  # test for to allow access to only permitted subomains
  class ExcludedSubdomainConstraint
    def self.matches?(request)
      subdmn = ExcludedSubdomains.subdomains #%w{www admin administrator root f055}
      request.subdomain.present? && !subdmn.include?(request.subdomain)
    end
  end

  constraints ExcludedSubdomainConstraint do
    get 'welcome', to: 'welcome#index', as: :welcome
    get 'changelog', to: 'changelogs#index', as: :changelog
    resources :members
    get 'members/:id/resend_invitation' => 'members#resend_invitation', as: :resend_invitation
    delete 'members/:id/remove_invitation' => 'members#remove_invitation', as: :remove_invitation
    devise_scope :user do
      get 'logout', to: 'devise/sessions#destroy'
    end
    get 'dashboard', to: 'dashboards#index', as: :dashboard
    resources :workspaces
  end
end
