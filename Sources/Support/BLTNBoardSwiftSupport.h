/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

// Workaround needed to allow static library usage through Cocoapods.
// https://github.com/CocoaPods/CocoaPods/issues/7594
// https://github.com/mxcl/PromiseKit/issues/825
#if __has_include("BLTNBoard-Swift.h")
	#import "BLTNBoard-Swift.h"
#else
	#import <BLTNBoard/BLTNBoard-Swift.h>
#endif
