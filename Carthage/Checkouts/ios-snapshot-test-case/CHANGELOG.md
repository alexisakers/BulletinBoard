# Change Log

All notable changes to this project will be documented in this file.

## 4.0.0

  - Adds the ability to override the folder name where snapshots are going to be saved for each test class.
  - Support for library test bundles.
  - Support for setting `IMAGE_DIFF_DIR` using preprocessor or a property on `FBSnapshotTestController`.
  - Formatted the project using clang-format to escape two space indentation hell.
  - Added nullability annotations to the entire project to improve portability with Swift and the clang analyzer.
  - Deprecated `deviceAgnostic` in favour of `agnosticOptions`.
  - Remove dead Swift code in `SwiftSupport.swift`

  Apologies for the churn in this version. We realised after we had merged #14 that we broke semantic versioning with `3.1.0` so we unpublished that podspec and then merged all of the breaking changes we had on the backlog that were pressing.

## 3.0.0

  - Project has been relicensed to MIT via the original project and Facebook's PATENTS file has been removed with their blessing. Thank you Facebook!
  - Deployment Target is now iOS 8.1, Base SDK is 11.2.
  - Updated for CocoaPods 1.4.0.

## 2.2.0

  - Added ability to have more fine–grained control over snapshot file names using deviceAgnostic with a new flag 'agnosticOptions'.
  - Updated for Xcode 9.2 and Swift 4.
  - Fixed a bug where the bounds of a snapshot would be incorrect after UIAppearance triggers a change in the intrinsic content size of the UIView being snapshotted.

## 2.1.6

  - Fixes to podspec

## 2.1.5

  - Project transferred to Uber; license changed from BSD to MIT
  - Swift 3.1 support
  - Fixed broken FB_REFERENCE_IMAGE_DIR preprocessor macro

## 2.1.4

  - Swift 3 support (#194)
  - Replace big macro with Objective-C method for easier debugging (#180)

## 2.1.3

  - Allow to compile with Xcode 7 and Xcode 8 Swift 2.3 (#179)

## 2.1.2

  - Disabled Bitcode for tvOS target (#169)
  - Added user target in podspec (#165)

## 2.1.1

  - Added tvOS support for cocoapods (#163)
  - Remove custom module map for cocoapods (#141)

## 2.1.0

  - Changed FBSnapshotTestController from private to public in the xcodeproj (#135)
  - Added device agnostic tests and assertions (#137)
  - Fixed fb_imageForView edge cases (#138, #153)
  - Changed project setting to match the code style (#139)
  - Fixed propagating the correct file name and line number on Swift (#140)
  - Added framework support for tvOS (#143)
  - Added optional tolerance parameter on Swift (#145)
  - Added images to comparison errors (#146)
  - Fixed build for Xcode 7.3 (#152)

## 2.0.7

  - Change FBSnapshotTestController from private to public (#129)

## 2.0.6

  - Added modulemap and podspec fixes to build with Xcode 7.1 (#127)

## 2.0.5

  - Swift 2.0 (#111, #120) (Thanks to @pietbrauer and @grantjk)
  - Fix pod spec by disabling bitcode (#115) (Thanks to @soleares)
  - Fix for incorrect errors with multiple suffixes (#119) (Thanks to @Grubas7)
  - Support for Model and OS in image names (#121 thanks to @esttorhe)

## 2.0.4

  - Support loading reference images from the test bundle (#104) (Thanks to @yiding)
  - Fix for retina tolerance comparisons (#107)

## 2.0.3

  - New property added `usesDrawViewHierarchyInRect` to handle cases like `UIVisualEffect` (#70), `UIAppearance` (#91) and Size Classes (#92) (#100)

## 2.0.2

  - Fix for retina comparisons (#96)

## 2.0.1

  - Allow usage of Objective-C subspec only, for projects supporting iOS 7 (#93) (Thanks to @x2on)

## 2.0.0

  - Approximate comparison (#88) (Thanks to @nap-sam-dean)
  - Swift support (#87) (Thanks to @pietbrauer)

## 1.8.1

  - Prevent mangling of C function names when compiled with a C++ compiler. (#79)

## 1.8.0

  - The default directories for snapshots images are now **ReferenceImages_32** (32bit) and **ReferenceImages_64** (64bit) and the suffix depends on the architecture when the test is running. (#77)
  	- If a test fails for a given suffix, it will try to load and compare all other suffixes before failing.
  - Added assertion on setRecordMode. (#76)
