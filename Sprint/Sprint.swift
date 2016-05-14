//
//  Sprint.swift
//  Ignite
//
//  Created by Josh Wright on 5/13/16.
//  Copyright © 2016 Josh Wright. All rights reserved.
//

import Foundation

public enum SprintQueue {
    
    case Main
    case UserInteractive
    case UserInitiated
    case Utility
    case Background
    case Custom(dispatch_queue_t)
    
    public static func customSerial(label: String) -> SprintQueue {
        return Custom(dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL))
    }
    
    public static func customConcurrent(label: String) -> SprintQueue {
        return Custom(dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT))
    }
    
    public func barrierSync(block: dispatch_block_t) -> Sprint {
        dispatch_barrier_sync(self.dispatchQueue, block)
        return Sprint(block: block)
    }
    
    public func barrierAsync(block: dispatch_block_t) -> Sprint {
        dispatch_barrier_async(self.dispatchQueue, block)
        return Sprint(block: block)
    }
    
    // run asynchronously
    public func async(block: dispatch_block_t) -> Sprint {
        dispatch_async(self.dispatchQueue, block)
        return Sprint(block: block)
    }
    
    // run synchronously
    public func sync(block: dispatch_block_t) -> Sprint {
        dispatch_sync(self.dispatchQueue, block)
        return Sprint(block: block)
    }
    
    public func after(seconds: Double, block: dispatch_block_t) -> Sprint {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC))), self.dispatchQueue, block)
        return Sprint(block: block)
    }
    
    public func apply(iterations: Int, block: Int -> ()) {
        dispatch_apply(iterations, self.dispatchQueue, block)
    }
    
    // get the queue assciated with this type
    private var dispatchQueue: dispatch_queue_t {
        switch self {
        case .Main: return dispatch_get_main_queue()
        case .UserInteractive:
            return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
        case .UserInitiated:
            return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        case .Utility:
            return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        case .Background:
            return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        case .Custom(let queue):
            return queue
        }
    }
}

public struct SprintGroup {
    
    private let group: dispatch_group_t
    
    init() {
        self.group = dispatch_group_create()
    }
    func enter() {
        dispatch_group_enter(group)
    }
    
    func leave() {
        dispatch_group_leave(group)
    }
    
    func async(queue: SprintQueue, block: dispatch_block_t) -> Sprint {
        dispatch_group_async(group, queue.dispatchQueue, block)
        return Sprint(block: block)
    }
    
    func finished(queue:SprintQueue, block: dispatch_block_t) -> Sprint {
        dispatch_group_notify(group, queue.dispatchQueue, block)
        return Sprint(block: block)
    }
    
    public func wait(timeout seconds: Double? = nil) -> Bool {
        if let seconds = seconds {
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
            return dispatch_group_wait(group, time) == 0
        } else {
            return dispatch_group_wait(group, DISPATCH_TIME_FOREVER) == 0
        }
    }
}

public struct Sprint {
    
    private let block: dispatch_block_t
    
    init(block: dispatch_block_t) {
        self.block = block
    }
    
    public func finished(queue: SprintQueue, block: dispatch_block_t) {
        dispatch_block_notify(self.block, queue.dispatchQueue, block)
    }
    
    public func cancel() {
        dispatch_block_cancel(block)
    }
}
