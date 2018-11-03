# Library vs Application Test Bundles

* Authors: [Alan Zeino](https://github.com/alanzeino)

## Introduction

Developers writing unit tests for iOS using XCTest typically use Application Test Bundles without much consideration as to _why_ their tests need to be inside an Application Test Bundle, as opposed to a Library Test Bundle. This document describes what you can and can't do with both, and why you might want to use a Library Test Bundle.

Library Test Bundles were once called _Logic_ Test Bundles in Apple's nomenclature. In the context of this document, both Library and Logic are interchangeable.

### Application tests

Unit tests that test parts of an application (such as UIViewControllers, UIWindows, UIViews) should typically be part of an Application test bundle. An Application test bundle requires a Test Host (an application to run your tests in) and at test run time, a simulator too. The attached Test Host provides access to some iOS APIs that only work inside Application test bundles. In our experience, we've seen these:

* `-[UIControl sendActionsForControlEvents:]` — This API is commonly used to trigger actions at runtime and sometimes you might want to use it inside a test to trigger a particular code path which is ordinarily run when a user performs an action. While it does not work inside a Library test bundle, we've written our own version for unit tests (see 'Code Snippets' below) that works well for this need.
* `UIAppearance` — Most `UIAppearance` APIs break when there is no test host present.
* `UIWindow` — You cannot make a `UIWindow` you created during your test the 'key window' because `makeKeyAndVisible` crashes at test run time. One workaround is to instead set `hidden` to `false` on the `UIWindow` instance you created. However there still won't be a 'key window' so if you have code that adds a `UIView` as a subview of the `keyWindow` then that will break.
* Keychain — Keychain operations require an application test bundle.

### Library tests
Unit tests that test parts of a framework or library should be part of a Library test bundle. This does not strictly require a Test Host. Not using a Test Host has some advantages: 

* No need to install anything, which makes running your tests faster and reduces the likelihood of Simulator instability
* The Test Host application will start an application lifecycle, which is state that can cause instability in your tests
* Only one host application can run at the same time in a Simulator, so tests with a Test Host cannot parallelize on one simulator. The `xctest` stub process spawned without a Test Hist isn’t a full iOS application, so multiple can run in parallel sharing a single simulator.

If you are using [Buck](https://buckbuild.com/), removing the `test_host_app` option for `apple_test()` rules will allow Buck and `xctool` to run your test bundles in parallel.

### Code Examples
#### ub_sendActionsForControlEvents:
This code snippet shows how you might replace `UIControl`'s `sendActionForControlEvents:` in a test that is inside a library  test bundle. Since it doesn't have universal application we haven't included it directly in the project. If you decide to use this category, make sure it can only be seen inside unit tests and not all of your code.

```
/**
 Copyright (c) 2018 Uber Technologies, Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

@interface UIControl (SendActions)

/**
 In library test bundles with no test host, the default sendActionsForControlEvents: does not work.

 This replacement mimics the same idea of that method by finding all the targets associated with the control, finding all the actions on that target for the given control event, and invoking those actions on those targets.

 @param controlEvents A bitmask whose set flags specify the control events for which action messages are sent.
 */
- (void)ub_sendActionsForControlEvents:(UIControlEvents)controlEvents;

@end

/**
 UIControlEvents has options in the range 0-8, 12-13, 16-19. 9-11 are reserved for future UIControlEventTouch* options. 14-15 are reserved for other options. If new options are added after 19, this const will need to be updated.
 */
static NSUInteger const UIControlEventsMaxOffset = 19;


@implementation UIControl (UberTesting)

- (void)ub_sendActionsForControlEvents:(UIControlEvents)controlEvents
{
  for (NSUInteger i = 0; i < UIControlEventsMaxOffset; i++) {
    UIControlEvents controlEvent = 1 << i;
    if (controlEvents & controlEvent) {
      for (id target in self.allTargets) {
        NSArray<NSString *> *targetActions = [self actionsForTarget:target forControlEvent:controlEvent];
        for (NSString *action in targetActions) {
          SEL selector = NSSelectorFromString(action);
          IMP imp = [target methodForSelector:selector];
          void (*func)(id, SEL, id) = (void *)imp;
          func(target, selector, self);
        }
      }
    }
  }
}

@end

```