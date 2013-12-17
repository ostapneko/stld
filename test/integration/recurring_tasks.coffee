casper.test.setUp (done) ->
  casper.start().then ->
    casper.open("http://test-stld/truncate_db", { method: 'delete' })
  .run(done)

casper.test.begin('Recurring tasks', 2, (test) ->
  casper.start("http://test-stld")

  # CREATE RECURRING TASK AND ENABLE IT

  casper.then ->
    this.click('button#rec-create')
    this.fillSelectors('form#rec-create-form', {
      'input[name="rec-description"]': 'recurring task 1',
      'select[name="rec-frequency"]': 1
    }, true)

  casper.waitForSelector(
    '.recurring-task',
    -> test.assertTextExists('recurring task 1', 'recurring task successfully created'),
    -> test.fail("Could not find the task after creation"),
    100)

  # DISABLE TASK
  # ENABLE TASK
  # EDIT TASK

  # DELETE TASK

  casper.then ->
    this.click('button#rec-delete')

  casper.waitWhileSelector(
    '.recurring-task',
    -> test.assertTextDoesntExist('recurring task 1', 'recurring task successfully removed'))

  # CREATE RECURRING TASK WITHOUT ENABLING
  # CREATE RECURRING TASK WITHOUT FREQUENCY -> SHOULD FAIL
  # CREATE EXISTING TASK -> SHOULD FAIL
  casper.run ->
    test.done())
