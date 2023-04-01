# Logger
### An unified logging system for iOS and macOS with internal caching system as well as server replication support.
<img src="https://github.com/hamed8080/logger/raw/main/images/icon.png"  width="64" height="64">
<br />

## Features

- [x] Simplify logging by taking advantage of logging on a delegate or a server.
- [x] Mechanism to distinguish the type of the logs.
- [x] Caching logs on an internal core data storage.
- [x] Queue sending of logs to the server.
<br/>

## Installation

#### Swift Package Manager(SPM) 

Add in `Package.swift` or directly in `Xcode Project dependencies` section:

```swift
.package(url: "https://github.com/hamed8080/logger.git", .upToNextMinor(from: "1.0.0")),
```

#### [CocoaPods](https://cocoapods.org) 

Add in `Podfile`:

```ruby
pod 'Logger'
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

## [Documentation](https://hamed8080.gitlab.io/logger/documentation/logger/)
For more information about how to use Logger visit [Documentation](https://hamed8080.gitlab.io/logger/documentation/logger/) 
<br/>
<br/>

## Contributing to Logger
Please see the [contributing guide](/CONTRIBUTING.md) for more information.

<!-- Copyright (c) 2021-2022 Apple Inc and the Swift Project authors. All Rights Reserved. -->
