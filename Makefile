tests: sort
	@xcodebuild -project Osusume.xcodeproj -scheme "Osusume" -sdk iphonesimulator -destination "platform=iOS Simulator,OS=9.2,name=iPhone 6" test

bootstrap:
	@carthage bootstrap --platform iOS

ci: bootstrap tests

sort:
	perl ./bin/sortXcodeProject Osusume.xcodeproj/project.pbxproj

update:
	@carthage update --platform iOS

