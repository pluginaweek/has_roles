class Admin::UsersController < Admin::BaseController
  before_filter :authorization_required, :only => :destroy
  
  def index
    render :text => 'Welcome!'
  end
  
  def destroy
    render :text => 'Destroyed!'
  end
end
