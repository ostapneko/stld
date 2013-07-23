$(function() {
  var btns = $(".show-task-form, .hide-task-form")

  function getBtnInfo(btn) {
    return btn.attr('id').split("-");
  };

  function getTaskId(btn) {
    return getBtnInfo(btn)[4];
  };

  function getTaskType(btn) {
    return getBtnInfo(btn)[1];
  };

  function getDualBtn(btn) {
    var showOrHide = getBtnInfo(btn)[0];
    var dualRole = showOrHide === "show" ? "hide" : "show";
    dualBtnId = "#" + dualRole + "-" + getTaskType(btn) + "-task-form-" + getTaskId(btn);
    return $(dualBtnId);
  };

  function getFormForBtn(btn) {
    var formId = "#" + getTaskType(btn) + "-task-form-" + getTaskId(btn);
    return $(formId);
  };

  btns.click(function() {
    $(this).toggle();
    var dual = getDualBtn($(this));
    dual.toggle();
    var form = getFormForBtn($(this));
    form.toggle();
  });

  var deleteTaskForm = $('.delete-task');

  deleteTaskForm.submit(function(ev){
    ev.preventDefault();
    var form = this;
    var data = $(this).serialize();
    $.ajax({
      url: form.action,
      data: data,
      type: form.method,
      dataType: 'json',
      success: function( json ) {
        if (json['errors'].length < 1) {
          var successAlert = "<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert'>×</button>" + json['notice'] + "</div>"
          var id = json['id'].toString();
          $('h1').before(successAlert);
          $('#task-' + id).remove();
        }
        else {
          var errorsAlert = "<div class='alert alert-error'><button type='button' class='close' data-dismiss='alert'>×</button>" + json['errors'] + "</div>"
          $('h1').before(errorsAlert);
        }
      },
      // code to run if the request fails; the raw request and status codes are passed to the function
      error: function( xhr, status ) {
        var errorsAlert = "<div class='alert alert-error'><button type='button' class='close' data-dismiss='alert'>×</button>A server error occurred; sorry for that!</div>"
        $('h1').before(errorsAlert);
      }
    });
  });
});
