json.array! @tasks do |task|
  @task = task
  json.partial! partial: 'task', locals: { task: @task }
end
