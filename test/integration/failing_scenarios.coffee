casper.test.setUp (done) ->
  casper.start().then ->
    casper.open("http://test-stld/truncate_db", { method: 'delete' })
  .run(done)

casper.test.begin('Failing scenarios', 6, (test) ->
  casper.start("http://test-stld")

  # CREATE EXISTING RECURRING TASK

  casper.then ->
    this.click('button#rec-create')
    this.fillSelectors('form#rec-create-form', {
      'input[name="rec-description"]': 'recurring task 1',
      'select[name="rec-frequency"]': 1
    }, true)

  casper.then ->
    this.click('button#rec-create')
    this.fillSelectors('form#rec-create-form', {
      'input[name="rec-description"]': 'recurring task 1',
      'select[name="rec-frequency"]': 1
    }, true)

  casper.waitForSelector(
    '.alert-danger',
    -> test.assertTextExists('description is already taken', 'duplicate task cannot be created'),
    -> test.fail("Could not find error message"),
    100)

  # CREATE UNIQUE TASK WITHOUT DESCRIPTION

  casper.then ->
    this.click('button.close-alert')
    this.click('button#uq-create')
    this.fillSelectors('form#uq-create-form',
      {'input[name="uq-description"]': ''}, true)

  casper.waitForSelector(
    '.alert-danger',
    -> test.assertTextExists('description is not present', 'unique task without description is not valid'),
    -> test.fail("Could not find error message"),
    100)

  # CREATE RECURRING TASK WITHOUT FREQUENCY

  casper.then ->
    this.click('button.close-alert')
    this.click('button#rec-create')
    this.fillSelectors('form#rec-create-form', {
      'input[name="rec-description"]': 'recurring task 3',
    }, true)

  casper.waitForSelector(
    '.alert-danger',
    -> test.assertTextExists('frequency is not in range or set', 'recurring task cannot be created without frequency'),
    -> test.fail("Could not find error message"),
    100)

  # EDIT UNIQUE TASK WITH BLANK DESCRIPTION
  casper.then ->
    this.click('button.close-alert')
    this.click('button#uq-create')
    this.fillSelectors('form#uq-create-form',
      {'input[name="uq-description"]': 'unique task 1'}, true)

  casper.waitForSelector(
    '.unique-task',
    -> test.assertTextExists('unique task 1', 'unique task successfully created'),
    -> test.fail("Could not find the task after creation"),
    100)

  casper.then ->
    this.click('button#uq-edit')
    this.fillSelectors('form#uq-edit-form',
      {'input[name="uq-description"]': ''}, true)

  casper.waitForSelector(
    '.alert-danger',
    -> test.assertTextExists('description is not present', 'task cannot be edited with empty description'),
    -> test.fail("Could not find error message"),
    100)

  # EDIT RECURRING TASK WITH BLANK DESCRIPTION

  casper.then ->
    this.click('button.close-alert')
    this.click('button#rec-edit')
    this.fillSelectors('form#rec-edit-form', {
      'input[name="rec-description"]': '',
    }, true)

  casper.waitForSelector(
    '.alert-danger',
    -> test.assertTextExists('description is not present', 'task cannot be edited with empty description'),
    -> test.fail("Could not find error message"),
    100)

  casper.run ->
    test.done())
