json.array! @tasks do |task|
  json.task task, :id, :content, :status

  json.set! :url do
    json.set! :switch_status, task_switch_status_path(task.id)
    json.set! :delete, task_path(task)
  end
end
