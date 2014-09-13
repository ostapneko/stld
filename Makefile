.DEFAULT_GOAL := all

APP_FOLDER            = public/app

STYLES_VENDOR_DIR     = $(APP_FOLDER)/styles/vendor
BOOTSTRAP_CSS         = $(STYLES_VENDOR_DIR)/bootstrap.no-icons.min.css

SCRIPTS_DIR           = $(APP_FOLDER)/scripts
SCRIPTS_VENDOR_DIR    = $(SCRIPTS_DIR)/vendor
ANGULAR               = $(SCRIPTS_VENDOR_DIR)/angular.min.js


all: $(BOOTSTRAP_CSS) $(ANGULAR) scripts

$(BOOTSTRAP_CSS): | $(STYLES_VENDOR_DIR)
	wget 'http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.no-icons.min.css' -O $(BOOTSTRAP_CSS)

$(STYLES_VENDOR_DIR):
	mkdir -p $(STYLES_VENDOR_DIR)

$(ANGULAR): | $(SCRIPTS_VENDOR_DIR)
	wget 'https://ajax.googleapis.com/ajax/libs/angularjs/1.2.0/angular.min.js' -O $(ANGULAR)

$(SCRIPTS_VENDOR_DIR):
	mkdir -p $(SCRIPTS_VENDOR_DIR)

scripts:
	coffee -c $(SCRIPTS_DIR)

.PHONY: rbtest, e2e
rbtest:
	bundle exec script/test.rb
e2e:
	coffee -c test/integration/*.coffee
	casperjs test test/integration/*.js
