class ApplicationController < ActionController::API
  # 「NoMethodError (undefined method 'respond_to' for an instance of Devise::SessionsController):」の対策
  include ActionController::MimeResponds
end
