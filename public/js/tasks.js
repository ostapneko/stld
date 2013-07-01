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
});
