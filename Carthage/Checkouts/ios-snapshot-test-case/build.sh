#!/bin/sh

set -eu

function ci_lib() {
    NAME=$1
    xcodebuild -project FBSnapshotTestCase.xcodeproj \
               -scheme "FBSnapshotTestCase iOS" \
               -destination "platform=iOS Simulator,name=${NAME}" \
               -sdk iphonesimulator \
               build test
}

function ci_demo() {
    NAME=$1
    pushd FBSnapshotTestCaseDemo
    pod install
    xcodebuild -workspace FBSnapshotTestCaseDemo.xcworkspace \
               -scheme FBSnapshotTestCaseDemo \
               -destination "platform=iOS Simulator,name=${NAME}" \
               build test
    popd
}

ci_lib "iPhone 7" && ci_demo "iPhone 7"
ci_lib "iPhone X" && ci_demo "iPhone X"
