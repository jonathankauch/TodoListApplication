# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  KEY_ENTER = 13

  class Task
    constructor: (@id, @content, @status, @switch_status_url, @task_path ) ->

    build: ->
      $block = $('.bs-callout.hidden').clone()
      $block.attr('id', 'task-' + @id)
      if @status is 1
        mode = 'info'
      else
        $block.find('.status-icon').find('i').toggleClass('checked')
        mode = 'success'
      $block.addClass('bs-callout-' + mode)
      $block.toggleClass('hidden')
      $block.find('p').text(@content)
      $block.find('.suppress-icon').attr('href', @task_path)
      $block.find('.status-btn').attr('href', @switch_status_url)
      console.log $block
      return $block

  addToTaskList = (data) ->
    task = new Task data.task.id, data.task.content, data.task.status, data.url.switch_status, data.url.task
    $block = task.build()
    $('.task-list').prepend($block)
    # id = data.task.id
    # content = data.task.content
    # url_delete = data.url.delete
    # url_switch_status = data.url.switch_status
    #
    # if data.task.status is 0
    #   status = 'success'
    #   checked = 'checked'
    # else
    #   status = 'info'
    #   checked = ''
    #
    # $('.task-list').prepend("
    #   <div id='task-" + id + "' class='bs-callout bs-callout-" + status + "'>
    #     <h4>
    #       Task:
    #     </h4>
    #     <p>
    #     " + content + "
    #     </p>
    #     <div class='suppress-icon'>
    #       <a href='"+ url_delete + "' class='suppress-btn' data-method='DELETE' data-remote='true'>
    #         <i class='fa fa-times'></i>
    #       </a>
    #     </div>
    #     <div class='status-icon'>
    #       <a href='"+ url_switch_status + "' class='status-btn' data-method='PUT' data-remote='true'>
    #         <i class='fa fa-2x fa-thumbs-o-up " + checked + "'></i>
    #       </a>
    #     </div>
    #   </div>
    # ")

  removeAllTask = ->
    $('.bs-callout-info, .bs-callout-success').each ->
      $(@).remove()

  $('.task-inprogress-btn, .task-all-btn, .task-completed-btn').on 'ajax:success', (event, data, status, xhr) ->
    removeAllTask()
    addToTaskList(item) for item in data

  $('.clear-all-btn').on 'ajax:success', (event, data, status, xhr) ->
    removeAllTask()

  $('.task-list').on 'ajax:success', 'div a.suppress-btn', (event, data, status, xhr) ->
    $(event.target).closest('div.bs-callout').fadeOut 1000, () ->
      $(@).remove()
    $.notify("Your task has been deleted !", 'success');

  $('.task-list').on 'ajax:success', 'div a.status-btn', (event, data, status, xhr) ->
    $parent = $(event.target).closest('div.bs-callout')
    if data.status is 0
      $(@).find('i').toggleClass('checked')
      $parent.toggleClass('bs-callout-info bs-callout-success')
      $.notify("Your task has been completed !", 'success');
    else
      $(@).find('i').toggleClass('checked')
      $parent.toggleClass('bs-callout-success bs-callout-info')
      $.notify("Your task is in progress !", 'success');

  $('.task-list').on 'ajax:error', (event, xhr, status, error) ->
    $.notify("Cannot access to the task !", 'error')

  $('.content-field').keyup (e) ->
    if e.keyCode is KEY_ENTER
      url = $(@).attr('data-url')
      data = {
        task: {
          content: $(@).val(),
          status: 1
        }
      }

      $.ajax
        url: url,
        type: 'POST',
        dataType: 'JSON',
        data: data
        error: (xhr, status, error) ->
          $.notify("I can't create your task !", 'error');
        success: (data, status, xhr) ->
          addToTaskList(data)
          $.notify("A new task has been created !", 'success');
          $('.content-field').val('')
