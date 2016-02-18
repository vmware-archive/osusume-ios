.PHONY: bootstrap ci sort tests tests-without-sorting update

bootstrap:
	@carthage bootstrap --platform iOS

ci: bootstrap tests-without-sorting

sort:
	perl ./bin/sortXcodeProject Osusume.xcodeproj/project.pbxproj

tests: sort tests-without-sorting

tests-without-sorting:
	@xcodebuild -project Osusume.xcodeproj -scheme "Osusume-Staging" -sdk iphonesimulator -destination "platform=iOS Simulator,OS=9.2,name=iPhone 6" test

update:
	@carthage update --platform iOS

