/*
*  Copyright (c) 2015-2018, Facebook, Inc.
*
*  This source code is licensed under the MIT license found in the
*  LICENSE file in the root directory of this source tree.
*
*/

import FBSnapshotTestCase

class FBSnapshotTestCaseSwiftTest: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }

  func testExample() {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    view.backgroundColor = UIColor.blue
    FBSnapshotVerifyView(view)
    FBSnapshotVerifyLayer(view.layer)
  }
}
