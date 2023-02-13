class AddDeadlineStatusPriorityToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :deadline, :date
    add_column :tasks, :status, :integer
    add_column :tasks, :priority, :integer
  end
end
