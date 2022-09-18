/*
Copyright (C) 2016 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
A subclass of `NSOperation` that maps the different states of an `NSOperation`
        to an explicit `state` enum.
*/

import Foundation

class SceneOperation: Operation {
    private let lockQueue = DispatchQueue(label: "com.example.apple-samplecode.asyncoperation", attributes: .concurrent)

    override var isAsynchronous: Bool {
        return true
    }

    private var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }

    override func start() {
        isFinished = false
        isExecuting = true
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }
}
