# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('.accordion_tasks').accordion()

  $('.accordion_lists').accordion()
  $('.complete_list').click ->
    list_id = $(this).attr('list_id')
    $.ajax
      url: '/complete_list'
      type: 'POST'
      data: {list_id:list_id}

  $('.add_list').click ->
    $('#new_list').trigger('reset')




  $('#add_list').click ->
    $('.focus').removeClass('focus')
    $('#list').remove()
    $('#add_task').remove()
    $('#undo_favorite').remove()
    $('#form_find_favorite').hide()
    $('#form_list_div').show()
    $('#form_task_div').hide()
    $('#new_task').trigger('reset')
    $('#public_lists').remove()




  #$('#new_list').submit ->
  #  alert('enviou')

  $(".my_list").click ->
    $.get '/show_list',
      list_id: $(this).attr('list_id')


  $(".favorites").click ->
    $.get '/show_favorite',
      list_id: $(this).attr('list_id')

  $(".clickable").click ->
    $('.focus').removeClass('focus')
    $(this).addClass('focus')

  $('#find_list').click ->
    $('.focus').removeClass('focus')
    $('#list').remove()
    $('#undo_favorite').remove()
    $('#add_task').remove()
    $('#form_list_div').hide()
    $('#form_find_favorite').show()

  $('#submit_search_button').click (e) ->
    e.preventDefault()
    $('#list').remove();
    $('#public_lists').remove()
    $('#search_list_form').submit()





