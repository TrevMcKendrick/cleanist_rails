class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    token    = auth_hash[:credentials][:token]
    name     = auth_hash[:info][:name]
    provider = auth_hash[:provider]
    @user = User.where(name: name, token: token, type: "#{provider}".capitalize).first_or_create
    # ap @user.archive
    session[:user_id] = @user.id
    redirect_to confirm_path

    # respond_to do |format|
    #   if @user.save
    #     # @user.delay(:run_at => 1.weeks.from_now).retrieve
    #     format.html { redirect_to @user, notice: 'User was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @user }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    session[:user_id] = nil
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def auth_hash
      request.env['omniauth.auth']      
    end
end
