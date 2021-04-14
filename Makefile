# Include config if exists
-include  config.make

# Put these into config.make to override with your setup
RESUME ?= resumes/jared.yaml
RSYNC_LOCATION ?= example.com:/var/www/resume/
TEMP_DIR ?= /tmp/resume
MAIN_BRANCH ?= jmbeach

PYTHON ?= ./venv/bin/python3
RSYNC ?= $(shell which rsync)
RSYNC_ARGS ?= aAXv
BUILD_DIR ?= build
BUILD_ARGS ?= --output_dir $(BUILD_DIR)
BUILD ?= $(PYTHON) build.py $(BUILD_ARGS)


.PHONY: clean html pdf publish


all: clean html pdf

html:
	$(BUILD) --format html $(RESUME)
	@echo "Done"

pdf:
	$(BUILD) --format pdf $(RESUME)

clean:
	@rm -rf ./build

publish:
	$(RSYNC) -$(RSYNC_ARGS) $(BUILD_DIR) $(RSYNC_LOCATION)

update_gh_pages:
	cp -r $(BUILD_DIR) $(TEMP_DIR)
	git stash
	git checkout gh-pages
	cp -rf $(TEMP_DIR)/* .
	rm -rf $(TEMP_DIR)

reload: clean html 
	chrome-cli reload
