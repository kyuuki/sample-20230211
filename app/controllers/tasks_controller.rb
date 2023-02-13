class TasksController < ApplicationController
  # 一覧画面
  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  # 詳細画面
  def show
    @task = Task.find(params[:id])
  end

  # 新規登録画面
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to task_url(@task), notice: "登録しました。"
    else
      render "new"
    end
  end

  # 編集画面
  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to task_url(@task), notice: "更新しました。"
    else
      render "edit"
    end
  end

  # 削除
  def destroy
    task = Task.find(params[:id])

    task.destroy
    redirect_to tasks_url, notice: "削除しました。"
  end

  private

  # Strong Parameters
  def task_params
    params.require(:task).permit(:title, :content)
  end
end
