class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.includes(:tasks).all
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_path(@user.id), notice: "登録しました。"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_user_path(@user.id), notice: "更新しました。"
    else
      render "edit"
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      redirect_to admin_users_url, notice: "削除しました。"
    else
      redirect_to admin_users_url, alert: "削除できませんでした。"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
