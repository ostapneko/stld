$ ->
  getBtnInfo = (btn) ->
    btn.attr("id").split "-"

  getTaskId = (btn) ->
    getBtnInfo(btn)[4]

  getTaskType = (btn) ->
    getBtnInfo(btn)[1]

  getDualBtn = (btn) ->
    showOrHide = getBtnInfo(btn)[0]
    dualRole = (if showOrHide is "show" then "hide" else "show")
    dualBtnId = "#" + dualRole + "-" + getTaskType(btn) + "-task-form-" + getTaskId(btn)
    $ dualBtnId

  getFormForBtn = (btn) ->
    formId = "#" + getTaskType(btn) + "-task-form-" + getTaskId(btn)
    $ formId

  btns = $(".show-task-form, .hide-task-form")
  btns.click ->
    $(this).toggle()
    dual = getDualBtn($(this))
    dual.toggle()
    form = getFormForBtn($(this))
    form.toggle()

  deleteTaskForm = $(".delete-task")

  alertString = (alertType, alertMsg) ->
    "<div class='alert alert-#{alertType}'><button type='button' class='close' data-dismiss='alert'>×</button>#{alertMsg}</div>"

  successResponse = (json) ->
    if json["errors"].length < 1
      id = json["id"].toString()
      successAlert = alertString("success", json["notice"])
      $("h1").before successAlert
      $("#task-" + id).remove()
    else
      errorsAlert = alertString('error', json["errors"])
      $("h1").before errorsAlert

  deleteTaskForm.submit (ev) ->
    ev.preventDefault()
    form = this
    data = $(this).serialize()
    $.ajax
      url: form.action
      data: data
      type: form.method
      dataType: "json"
      success: (json) ->
        successResponse(json)
      # if request fails; the raw request and status codes are passed to the fn
      error: (xhr, status) ->
        errorsAlert = alertString("error", "A server error occurred; sorry for that!")
        $("h1").before errorsAlert
