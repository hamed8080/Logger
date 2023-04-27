# Logger

<h5>An unified logging system for iOS and macOS with internal caching system as well as server replication support.</h5>

<img src="https://github.com/hamed8080/logger/raw/main/images/icon.png"  width="164" height="164">

## Features
- [x] Log on to a log server.
- [x] Log on to a local cache.
- [x] Schedule sending logs.
- [x] Distinguish between types of logs such as(`Request`, `Response`, `Internal`).
<br/>

## Installation

#### Swift Package Manager(SPM) 

Add in `Package.swift` or directly in `Xcode Project dependencies` section:

```swift
.package(url: "https://github.com/hamed8080/logger.git", .upToNextMinor(from: "1.0.2")),
```

#### [CocoaPods](https://cocoapods.org) 

Add in `Podfile`:

```ruby
pod 'Logger', :git => 'http://pubgi.fanapsoft.ir/chat/ios/logger.git', :tag => '1.0.2'
```
<br/>

## How to setup? 

```swift
let config = LoggerConfig(
 prefix: "YOUR_PREFIX",
 logServerURL: "YOUR_SERVER_ADDRESS",
 logServerMethod: "PUT",
 persistLogsOnServer: true,
 isDebuggingLogEnabled: true
)
let logger = Logger(config: config)
logger.delegate = delegate
```

## How to use? 
```swift
logger.log(title: "YOUR_TITLE", message: "YOUR_MESSAGE", persist: true, type: .internalLog)
logger.logJSON(title: "YOUR_TITLE", jsonString: "[{"name": "hamed"}]", persist: false, type: .received)
```
<br/>

## Clear Core data internal cache. 
```swift
Logger.clear(prefix: "YOUR_PREFIX")
```
<br/>

## [Documentation](https://hamed8080.github.io/logger/documentation/logger/)
For more information about how to use Logger visit [Documentation](https://hamed8080.github.io/logger/documentation/logger/) 
<br/>

## Contributing to Logger
Please see the [contributing guide](/CONTRIBUTING.md) for more information.

<!-- Copyright (c) 2021-2022 Apple Inc and the Swift Project authors. All Rights Reserved. -->
