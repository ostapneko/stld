.PHONY: rbtest, e2e
rbtest:
	bundle exec script/test.rb
e2e:
	casperjs test test/integration/*.js

migrate:
	./script/migrate
