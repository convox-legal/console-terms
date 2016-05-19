COMMONMARK=node_modules/.bin/commonmark
BUILD=build
DOCS=privacy terms

all: $(addprefix $(BUILD)/,$(addsuffix .html,$(DOCS)))

$(BUILD)/%.html: %.md $(BUILD) $(COMMONMARK)
	$(COMMONMARK) < $< > $@

$(BUILD):
	mkdir -p $(BUILD)

$(COMMONMARK):
	npm i

.PHONY: clean docker

clean:
	rm -rf $(BUILD)

DOCKER_TAG=convox-console-terms

docker:
	docker $(BUILD) -t $(DOCKER_TAG) .
	docker run -v $(shell pwd)/$(BUILD):/app/$(BUILD) $(DOCKER_TAG)
