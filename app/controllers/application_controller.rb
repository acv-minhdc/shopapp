class ApplicationController < ActionController::Base
  helper_method :count_cart

  def count_cart
    session[:cart].count
  end
end
