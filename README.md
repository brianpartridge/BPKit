## Setup

Add BPKit.xcodeproj as a project reference.
User Header Search Paths: BPKit/BPKit/**
Other Linker Flags: -ObjC -all_load
Add BPKit to Target Dependencies.
Add libBPKit.a to Link Binary With Libraries.
Add reference to the BPKitBundleResources directory, and include in targets.
Import BPKit.h in .pch file.