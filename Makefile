
sticky: main.m
	clang -framework Foundation -framework CoreGraphics -lobjc  main.m -o sticky -F /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.3.sdk/System/Library/Frameworks

sticky-debug: main.m
	clang -DDEBUG -framework Foundation -framework CoreGraphics -lobjc  main.m -o sticky-debug -F /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.3.sdk/System/Library/Frameworks