class CostsController < ApplicationController
  def index
  end

  def auth
    session[:alias] = request[:username] if request[:username]
  end
end
