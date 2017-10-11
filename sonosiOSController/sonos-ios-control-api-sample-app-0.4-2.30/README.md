Sonos iOS Control API Sample App
=======================================

The Sonos iOS Control API sample app is an application written in Swift that demonstrates how an iOS app can use SSDP and the Sonos Control API to control a group of Sonos players.

## Prerequisites

- Mac OS X
- Xcode 8
- CocoaPods 1.1.x ([click to learn how to install the latest stable version](https://guides.cocoapods.org/using/getting-started.html)).

## Run on the iOS Simulator

Download and unzip the `sonos-ios-control-api-sample-app-X.Y.Z.zip` package.

Change to the `sonosSampleApp` directory and install third party dependencies with CocoaPods:

```sh
pod install
```

If CocoaPods doesn't report any warnings, you may still need to modify permissions on a source file, so the build process can patch it.

```sh
chmod 666 Pods/CocoaAsyncSocket/Source/GCD/GCDAsyncUdpSocket.m
```

Start Xcode, click on "Open another project..." and select `SonosSampleApp.workspace` to open the entire workspace.

Select and build the `SonosSampleApp` scheme, then run the sample app on the iOS simulator.

You may need to enable developer mode on your Mac, if Xcode displays a dialog to enable it, click **Enable**.

After the initial splash screen, you should see a list of Sonos groups found on your local network. Select a Sonos group to take you to a "Now Playing" screen with transport controls.

## Sample App and Libraries

The sample app uses SSDP and Control API to connect and control Sonos players. The basic functionality is defined by these two Swift protocols:

- `SonosGroupDiscoveryProtocol` - discovers Sonos groups on the local network. Implemented by `SonosGroupDiscovery`.
- `PlaybackProtocol` - provides playback features for the Now Playing screen. Implemented by `SonosPlayer`.

Also included in this package are these Sonos libraries:

- `ControlApi` library - provides Swift classes for all Control API data structures.
- `SonosUtils` library - provides a data transport layer that abstracts out the underlying networking protocol used. Only the WebSocket protocol is implemented, as it is the only protocol currently supported for the Control API on Sonos players.

# Known Issues

* The "Edit Groups in Sonos" feature only works if the Sonos app is also installed on the same device as this sample app, so it cannot be used in the iPhone/iPad Simulator.
* Group volume control has not been implemented yet.
* Cannot be built with the pre-release CocoaPods version 1.0.0.beta.5.

# Read More

For more information and examples on how to discover, connect to and control a Sonos player using the Sonos Control API, see the [getting started page on the developer portal](https://developer.sonos.com/control-api/getting-started).

# Revision History

* Version 0.3:
  - Various bug fixes
  - Optimized downloading of album art
  - Security reviews and improvements
    - Verifies secure websocket certificate against Sonos root CAs; ignores hostname validation due to players' non-fixed IP addresses
  - Updated for Swift 3 and XCode 8
* Version 0.2: Initial Release
  - New UI assets and layouts.
  - Added group volume slider and mute button.
  - Added default album art.
  - Connection errors are handled and displayed.
  - `groupCoordinatorChanged` events are now being handled.
* Version 0.1: Early Release
