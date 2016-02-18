.PHONY: test bootstrap update

bootstrap:
	@carthage bootstrap --platform iOS

ci: bootstrap tests

tests:
	@xcodebuild -project Osusume.xcodeproj -scheme "Osusume-Staging" -sdk iphonesimulator -destination "platform=iOS Simulator,OS=9.2,name=iPhone 6" test

update:
	@carthage update --platform iOS

