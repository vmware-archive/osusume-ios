.PHONY: test bootstrap update

tests:
	./bin/runTests.sh

bootstrap:
	@carthage bootstrap --platform iOS

update:
	@carthage update --platform iOS

