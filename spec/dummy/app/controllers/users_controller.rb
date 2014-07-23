class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.roles.build
  end

  def new_recursive
    @user = User.new
  end

  def post_recursive
    raise ActiveModel::ForbiddenAttributesError unless simple_form_strong_params(:user).permitted?
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(simple_form_strong_params(:user))

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(simple_form_strong_params(:user))
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
