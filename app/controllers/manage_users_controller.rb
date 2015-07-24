class ManageUsersController < ApplicationController
  before_action :bounce_if_last_admin, only: [:destroy]
	before_action :bounce_incorrect_user, only: [:destroy, :edit, :update]
	before_action :set_user, only: [:edit, :destroy, :update]

  def index
  	@users = User.all.order(:admin).order(:name).paginate(page: params[:page], per_page: 10)
  end

  def new
    @user=User.new
  end

  def edit
  end

  def destroy
  	@user.destroy
  	redirect_to users_url, notice: 'User was successfully deleted...'
  end

  # POST /items
  # POST /items.json
  def create
    @user = User.create(user_params_for_new)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: 'user was successfully created.' }
        format.json { render :show, status: :created, location: users_url }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @user.update(user_params_for_edit)
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: users_url }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end



  private
  	def set_user
  		@user = User.find_by(id: params[:id])
  	end

  	def user_params_for_edit
      if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
        params.require(:user).permit(:name, :email, :image_url, :admin)
      else
        params.require(:user).permit(:name, :email, :image_url, :password, :password_confirmation, :admin)
      end
    end

    def user_params_for_new
      params.require(:user).permit(:name, :email, :image_url, :password, :password_confirmation, :admin)
    end

    def bounce_incorrect_user
    	if not user_signed_in?
    		redirect_to new_user_session_url, notice: "Sign in first please..."
    	else
    		redirect_to root_url, notice: "Sign in as admin please..." unless current_user.admin?
    	end
    end

    def bounce_if_last_admin
      if User.where(admin: true).count == 1
        redirect_to users_url, notice: "The last admin can not be deleted !!!"
      end
    end

end
