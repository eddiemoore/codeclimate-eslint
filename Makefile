.PHONY: image test citest integration

IMAGE_NAME ?= codeclimate/codeclimate-eslint

NPM_TEST_TARGET ?= test
NPM_INTEGRATION_TARGET ?= integration

DEBUG ?= false
ifeq ($(DEBUG),true)
	NPM_TEST_TARGET = test.debug
	NPM_INTEGRATION_TARGET = integration.debug
endif

image:
	docker build --rm -t $(IMAGE_NAME) .

integration: yarn.lock
	docker run -ti --rm \
		$(IMAGE_NAME) npm run $(NPM_INTEGRATION_TARGET)

test: yarn.lock
	docker run -ti --rm \
		$(IMAGE_NAME) npm run $(NPM_TEST_TARGET)

citest:
	docker run --rm \
		$(IMAGE_NAME) sh -c "npm run test && npm run integration"

yarn.lock: package.json image
	./bin/yarn install
