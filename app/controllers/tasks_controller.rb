class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taks }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        data = {
          task: @task,
          url: {
            switch_status: task_switch_status_path(@task.id),
            delete: task_path(@task)
          }
        }
        format.json { render json: data, status: :created }
      else
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # DELETE /tasks/clear_aall
  def clear_all
    Task.destroy_all

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # PUT /tasks/:id/switch_status
  def switch_status
    @task = Task.find params[:task_id]

    status = @task.status == 1 ? 0 : 1
    respond_to do |format|
      if @task.update_attribute :status, status
        format.json { render json: @task, status: :accepted}
      else
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /tasks/completed
  def completed_tasks
    @tasks = Task.completed

    send_tasks_formatted_in_json(@tasks)
  end

  # GET /tasks/completed
  def inprogress_tasks
    @tasks = Task.in_progress
    send_tasks_formatted_in_json(@tasks)
  end

  def all_tasks
    @tasks = Task.all
    send_tasks_formatted_in_json(@tasks)
  end

  private

  def send_tasks_formatted_in_json(items)
    return false if items.empty?
    data = []
    items.each do |task|
      tmp = {
        task: task,
        url: {
          switch_status: task_switch_status_path(task.id),
          delete: task_path(task)
        }
      }
      data << tmp
    end
    respond_to do |format|
      if data == false
        format.json { render json: @task.errors, status: :unprocessable_entity }
      else
        format.json { render json: data, status: :accepted }
      end
    end
  end
end
