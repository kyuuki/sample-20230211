class Admin::ApplicationController < ApplicationController
  before_action :admin_login_required

  private

  def admin_login_required
    unless current_user
      redirect_to new_session_path
      return
    end

    unless current_user.admin?
      redirect_to tasks_path, alert: "管理者以外はアクセスできません"
      return
    end
  end
end
