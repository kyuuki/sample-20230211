class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
    # ログインしているときは、ユーザーの新規登録画面に行かせない
    if logged_in?
      redirect_to tasks_path, notice: "ログイン中です。"
    end

    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.admin = false

    if @user.save
      # 保存の成功した場合の処理
      session[:user_id] = @user.id  # 同時にログインもさせる
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def show
    # 自分以外のユーザーのマイページにアクセスしたらタスク一覧に遷移させる
    if current_user.id != params[:id].to_i
      redirect_to tasks_path, notice: "自分以外のユーザーのマイページです。"
    end

    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
