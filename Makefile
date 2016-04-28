tests: sort units

ci: bootstrap tests integration

units:
	@xctool -project Osusume.xcodeproj -scheme "Osusume" -sdk iphonesimulator -destination "platform=iOS Simulator,OS=9.3,name=iPhone 6" test -parallelize -logicTestBucketSize 20

integration:
	@xctool -project Osusume.xcodeproj -scheme "Osusume-Staging" -sdk iphonesimulator -destination "platform=iOS Simulator,OS=9.3,name=iPhone 6" test -parallelize -logicTestBucketSize 20

bootstrap:
	@carthage bootstrap --platform iOS

sort:
	perl ./bin/sortXcodeProject Osusume.xcodeproj/project.pbxproj

bump:
	@./bin/bumpBuild.sh

update:
	@carthage update --platform iOS

