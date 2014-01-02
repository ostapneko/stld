casper.test.setUp (done) ->
  casper.start().then ->
    casper.open("http://test-stld/truncate_db", { method: 'delete' })
  .run(done)

casper.test.begin('Failing scenarios', 3, (test) ->
  casper.start("http://test-stld")

  # CREATE UNIQUE TASK WITHOUT DESCRIPTION

  casper.then ->
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
    this.click('button#close-alert')
    this.click('button#rec-create')
    this.fillSelectors('form#rec-create-form', {
      'input[name="rec-description"]': 'recurring task 3',
    }, true)

  casper.waitForSelector(
    '.alert-danger',
    -> test.assertTextExists('frequency is not in range or set', 'recurring task cannot be created without frequency'),
    -> test.fail("Could not find error message"),
    100)

  # CREATE EXISTING RECURRING TASK

  casper.then ->
    this.click('button#close-alert')
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

  casper.run ->
    test.done())
