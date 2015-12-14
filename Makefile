.PHONY: test bootstrap update

test:
	@xctool -scheme Osusume -sdk iphonesimulator test -only OsusumeTests

bootstrap:
	@carthage bootstrap --platform iOS

update:
	@carthage update --platform iOS

