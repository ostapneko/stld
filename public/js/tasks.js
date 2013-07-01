$(function() {
  function prepareForm(taskType) {
    var btns = $("#display-" + taskType + "-task-form, #hide-" + taskType + "-task-form");
    btns.click(function() {
      btns.toggle();
      $("#create-" + taskType + "-task-form").fadeToggle("fast");
    });
  }

  prepareForm("recurring");
  prepareForm("unique");
});
