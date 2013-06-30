$(function() {
  var btns = $("#display-recurring-task-form, #hide-recurring-task-form");
  btns.click(function() {
    btns.toggle();
    $("#create-recurring-task-form").fadeToggle("fast");
  });
});
