/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import Foundation
import UIKit

// MARK: AnimationChain

/**
 * A sequence of animations where animations are executed the one after the other.
 *
 * Animations are represented by `AnimationPhase` objects, that contain the code of the animation,
 * its duration relative to the chain duration, their curve and their individual completion handlers.
 */

public class AnimationChain {

    /// The total duration of the animation chain.
    public let duration: TimeInterval

    /// The initial delay before the animation chain starts.
    public var initialDelay: TimeInterval = 0

    /// The code to execute after animation chain is executed.
    public var completionHandler: () -> Void

    /// Whether the chain is being run.
    public private(set) var isRunning: Bool = false

    // MARK: Initialization

    private var animations: [AnimationPhase] = []
    private var didFinishFirstAnimation: Bool = false

    /**
     * Creates an animation chain with the specified duration.
     */

    public init(duration: TimeInterval) {
        self.duration = duration
        self.completionHandler = {}
    }

    // MARK: - Interacting with the Chain

    /**
     * Add an animation at the end of the chain.
     *
     * You cannot add animations if the chain is running.
     *
     * - parameter animation: The animation phase to add.
     */

    public func add(_ animation: AnimationPhase) {
        precondition(!isRunning, "Cannot add an animation to the chain because it is already performing.")
        animations.append(animation)
    }

    /**
     * Starts the animation chain.
     */

    public func start() {

        precondition(!isRunning, "Animation chain already running.")

        isRunning = true
        performNextAnimation()

    }

    private func performNextAnimation() {

        guard animations.count > 0 else {
            completeGroup()
            return
        }

        let animation = animations.removeFirst()

        let duration = animation.relativeDuration * self.duration
        let options = UIView.AnimationOptions(rawValue: UInt(animation.curve.rawValue << 16))
        let delay: TimeInterval = didFinishFirstAnimation ? 0 : initialDelay

        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animation.block) { _ in

            self.didFinishFirstAnimation = true

            animation.completionHandler()
            self.performNextAnimation()

        }

    }

    private func completeGroup() {
        isRunning = false
        completionHandler()
    }

}

// MARK: - AnimationPhase

/**
 * A member of an `AnimationChain`, representing a single animation.
 *
 * Set the `block` property to a block containing the animations. Set the `completionHandler` with
 * a block to execute at the end of the animation. The default values do nothing.
 */

public class AnimationPhase {

    /**
     * The duration of the animation, relative to the total duration of the chain.
     *
     * Must be between 0 and 1.
     */

    public let relativeDuration: TimeInterval

    /**
     * The animation curve.
     */

    public let curve: UIView.AnimationCurve

    /**
     * The animation code.
     */

    public var block: () -> Void

    /**
     * A block to execute at the end of the animation.
     */

    public var completionHandler: () -> Void

    // MARK: Initialization

    /**
     * Creates an animtion phase object.
     *
     * - parameter relativeDuration: The duration of the animation, as a fraction of the total chain
     * duration. Must be between 0 and 1.
     * - parameter curve: The animation curve
     */

    public init(relativeDuration: TimeInterval, curve: UIView.AnimationCurve) {

        self.relativeDuration = relativeDuration
        self.curve = curve

        self.block = {}
        self.completionHandler = {}

    }

}

