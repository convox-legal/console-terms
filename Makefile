COMMONMARK=node_modules/.bin/commonmark
BUILD=build
DOCS=privacy terms

all: $(addprefix $(BUILD)/,$(addsuffix .html,$(DOCS)))

$(BUILD)/%.html: %.md $(BUILD) $(COMMONMARK)
	sed 's/UPDATED/$(shell ./last-updated "$<")/' $< | $(COMMONMARK) > $@

$(BUILD):
	mkdir -p $(BUILD)

$(COMMONMARK):
	npm i

.PHONY: clean docker format

clean:
	rm -rf $(BUILD)

DOCKER_TAG=convox-console-terms

docker:
	docker $(BUILD) -t $(DOCKER_TAG) .
	docker run -v $(shell pwd)/$(BUILD):/app/$(BUILD) $(DOCKER_TAG)
	sudo chown -R `whoami` $(BUILD)

format:
	for doc in $(DOCS); do \
		fmt --uniform-spacing --width=72 $$doc.md > $$doc.tmp && \
		mv $$doc.tmp $$doc.md ; \
	done
