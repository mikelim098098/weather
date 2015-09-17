class SessionsController < ApplicationController
  def new
    @user = User.new
  end
  def create
    user = User.find_by(email: user_params[:email])
    # puts 'CHECKING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    # puts params.inspect
    # puts user.inspect
    if user && user.authenticate(user_params[:password])
      session[:id] = user.id
      redirect_to("/users/#{session[:id]}")
    else
      flash[:error] = "Email/Password was invalid."
      redirect_to("/sessions/new")
    end
  end
  def destroy
    session[:id] = nil;
    redirect_to('/homes')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone_number)
    end
end
