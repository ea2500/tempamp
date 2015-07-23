class ManageUsersController < ApplicationController
	before_action :bounce_incorrect_user, only: [:destroy, :edit, :update]
	before_action :set_user, only: [:edit, :destroy, :update]

  def index
  	@users = User.all.order(:name).paginate(page: params[:page], per_page: 10)
  end

  def edit
  end

  def destroy
  	@user.destroy
  	redirect_to users_url, notice: 'User was successfully deleted...'
  end

  def update
  	@user.update(user_params)
  	redirect_to users_url, notice: 'User was successfully updated...'
  end



  private
  	def set_user
  		@user = User.find_by(id: params[:id])
  	end

  	def user_params
      params.require(:user).permit(:name, :email, :image_url, :password, :password_confirmation, :admin)
    end

    def bounce_incorrect_user
    	if not user_signed_in?
    		redirect_to new_user_session_url, notice: "Sign in first please..."
    	else
    		redirect_to root_url, notice: "Sign in as admin please..." unless current_user.admin?
    	end
    end

end
