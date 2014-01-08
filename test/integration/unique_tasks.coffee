casper.test.setUp (done) ->
  casper.start().then ->
    casper.open("http://test-stld/truncate_db", { method: 'delete' })
  .run(done)

casper.test.begin('Unique tasks', 7, (test) ->
  casper.start("http://test-stld")

  # CREATE UNIQUE TASK IN CURRENT SPRINT

  casper.then ->
    this.click('button.uq-create')
    this.fillSelectors('form.uq-create-form',
      {'input[name="uq-description"]': 'unique task 1'}, true)

  casper.waitForSelector(
    '.unique-task',
    -> test.assertTextExists('unique task 1', 'unique task successfully created'),
    -> test.fail("Could not find the task after creation"),
    100)

  # EDIT UNIQUE TASK
  casper.then ->
    this.click('button.uq-edit')
    this.fillSelectors('form.uq-edit-form',
      {'input[name="uq-description"]': 'unique task 2'}, true)

  casper.waitForSelector(
    '.unique-task',
    -> test.assertTextExists('unique task 2', 'unique task successfully modified'),
    -> test.fail("Could not find modified task"),
    100)

  # POSTPONE TASK

  casper.then ->
    this.clickLabel('Postpone', 'button')

  casper.waitWhileSelector(
    '.unique-task',
    -> test.assertTextDoesntExist('unique task 2', 'unique task removed from this week panel '))

  casper.then ->
    this.clickLabel('backlog', 'a')

  casper.waitForSelector(
    '.unique-task',
    -> test.assertTextExists('unique task 2', 'unique task is in backlog'))

  # MOVE TASK INTO CURRENT SPRINT

  casper.then ->
    this.clickLabel('To Sprint', 'button')

  casper.waitWhileSelector(
    '.unique-task',
    -> test.assertTextDoesntExist('unique task 2', 'unique task removed from backlog panel '))

  casper.then ->
    this.clickLabel('this week', 'a')

  casper.waitForSelector(
    '.unique-task',
    -> test.assertTextExists('unique task 2', 'unique task is in current sprint'))

  # REMOVE UNIQUE TASK

  casper.then ->
    this.click('button.uq-done')

  casper.waitWhileSelector(
    '.unique-task',
    -> test.assertTextDoesntExist('unique task 2', 'unique task successfully removed'))

  casper.run ->
    test.done())
