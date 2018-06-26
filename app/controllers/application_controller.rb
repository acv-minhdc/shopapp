class ApplicationController < ActionController::Base
  helper_method :count_cart

  def count_cart
    return 0 if session[:cart].blank?
    session[:cart].count
  end
end
