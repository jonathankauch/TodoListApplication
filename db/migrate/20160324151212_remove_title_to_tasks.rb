class RemoveTitleToTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :title
  end

  def down
    add_column :tasks, :title, :string
  end
end
