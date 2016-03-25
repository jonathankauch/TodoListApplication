# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  addToTaskList = (data) ->
    id = data.task.id
    content = data.task.content
    url_delete = data.url.delete
    url_switch_status = data.url.switch_status

    if data.task.status is 0
      status = 'success'
      checked = 'checked'
    else
      status = 'info'
      checked = ''

    $('.task-list').prepend("
      <div id='task-" + id + "' class='bs-callout bs-callout-" + status + "'>
        <h4>
          Task:
        </h4>
        <p>
        " + content + "
        </p>
        <div class='suppress-icon'>
          <a href='"+ url_delete + "' class='suppress-btn' data-method='DELETE' data-remote='true'>
            <i class='fa fa-times'></i>
          </a>
        </div>
        <div class='status-icon'>
          <a href='"+ url_switch_status + "' class='status-btn' data-method='PUT' data-remote='true'>
            <i class='fa fa-2x fa-thumbs-o-up " + checked + "'></i>
          </a>
        </div>
      </div>
    ")

  removeAllTask = ->
    $('.bs-callout').each ->
      $(@).fadeOut 1000
      $(@).remove

  $('.task-list').on 'ajax:success', 'div a.suppress-btn', (event, data, status, xhr) ->
    $(event.target).closest('div.bs-callout').fadeOut 1000, () ->
      $(@).remove()
    $.notify("Your task has been deleted !", 'success');

  $('.task-completed-btn').on 'ajax:success', (event, data, status, xhr) ->
    removeAllTask()
    addToTaskList(item) for item in data

  $('.task-inprogress-btn').on 'ajax:success', (event, data, status, xhr) ->
    removeAllTask()
    addToTaskList(item) for item in data

  $('.task-all-btn').on 'ajax:success', (event, data, status, xhr) ->
    removeAllTask()
    addToTaskList(item) for item in data

  $('.clear-all-btn').on 'ajax:success', (event, data, status, xhr) ->
    removeAllTask()

  $('.task-list').on 'ajax:success', 'div a.status-btn', (event, data, status, xhr) ->
    $parent = $(event.target).closest('div.bs-callout')
    if data.status is 0
      $(@).find('i').addClass('checked')
      $parent.removeClass('bs-callout-info')
      $parent.addClass('bs-callout-success')
      $.notify("Your task has been completed !", 'success');
    else
      $(@).find('i').removeClass('checked')
      $parent.removeClass('bs-callout-success')
      $parent.addClass('bs-callout-info')
      $.notify("Your task is in progress !", 'success');


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
