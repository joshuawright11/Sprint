# Sprint
Swift Grand Central Dispatch made easier

## Overview
Sprint contains 3 types

- `Sprint`: a `dispatch_block_t` wrapper
- `SprintQueue`: a `dispatch_queue_t` wrapper
- `SprintGroup`: a `dispatch_group_t` wrapper

## Installation
ctrl+c, ctrl+p

CocoaPods and Carthage soon?

# Usage

## Queue Basics

`SprintQueue` is an enum whose value is related to the Quality of Service Class (QoS) it is running on:

- `Main`
- `UserInteractive`
- `UserInitiated`
- `Utility`
- `Background`

You can also have a custom queue, either serial or concurent

- `Custom(dispatch_queue_t)`
  
### Running on a Queue

```swift  
let backgroundQueue: SprintQueue = .Background
backgroundQueue.async {
	// background work
}.finished {
 	// background work is finished
 	// this block will be run on the same thread as async
}.finished(.Main) {
 	// this finish block will be run on the Main thread
 	// finish can be chained as many times as you want
}
```

There is also a `sync` method that runs synchronously.

### Running after a delay

`SprintQueue` has an `after` method to run a block after a set amount of seconds

```swift
let queue: SprintQueue = .Main
queue.after(5.0) {
	print("test")
}
	
// test will print after 5 seconds
```

### Parallelizing Loops

Loops can be parallelized using the `apply` method

```swift	
let dataToCompute: [SomeObject] = dataArray
var computedData = []
	
let queue: SprintQueue = .UserInitiated
queue.apply(dataToCompute.count) {
	index in
		let computedDatum = dataToCompute[index].computeData()
		computedData.apped(computedDatum)
}
```

### Cancelling blocks
Each method returns a `Sprint` which can then be cancelled (assuming it hasn't begun)

```swift
let sprint = SprintQueue.Background.async {
	// update cache
}
	
if sprint.cancel() {
	// the operation was successfully cancelled
} else {
	// cannot be cancelled; operation was already started
}
```

## Custom Queues
		
### Serial and Concurrent Queues
Besides the five built in QoS classes that Apple gives us, you can also create a custom Queue, either [serial or concurrent](http://stackoverflow.com/questions/19179358/concurrent-vs-serial-queues-in-gcd), via two static methods:

```swift
// a custom concurrent queue
let concurrentQueue = SprintQueue.customConcurrent(label: "com.example.concurrent")
	
// A custom serial queue
let serialQueue = SprintQueue.customSerial(label: "com.example.concurrent")
```
	
### Barrier operations

Barrier operations are written just like `async` and `sync` 

```swift
let customConcurrentQueue = SprintQueue.customConcurrent(label: "com.example.barrierExample")
	
customConcurrentQueue.async {
	// stuff A
}
	
customConcurrentQueue.barrierAsync {
	// stuff B 
	// (something that could result in a race if not ran in a barrier)
}
	
customConcurrentQueue.async {
	// stuff C
}
	
// stuff B is guarenteed to happen after A is completed finished and stuff C will not happen until B is completely finished
```
	
## Groups
You can also create dispatch groups for managing multiple asynchronous operations.

### Running asynchronous operations on a group
Each `SprintGroup` has a built in `async` method that handles the entering and leaving of the group for that operation

```swift	
let group = SprintGroup()
group.async(.Background) {
	// stuff 1
}
	
group.async(.UserInteractive) {
	// stuff 2
}
	
group.finished {
	// stuff 1 + 2 have finished running
	// functions exactly the same as Sprint.finished() with an optional SprintQueue parameter
}
```

### Wait

groups also have a `wait` method

```swift
group.async {
	// stuff
}
	
group.async {
	// more stuff
}
	
if group.wait(10.0) {
	// the stuff finished in 10.0 seconds
} else {
	// the stuff did NOT finish in 10.0 seconds and the wait timed out
}
```
	
### Entering and Leaving

you can also [manually enter and leave](http://stackoverflow.com/a/20910658/2938665) if you want to manually manage an associated block for your SprintGroup

```swift
group.enter()
	
youownapi.call {
	// stuff
	other.call {
		// more stuff
		callback.hell {
			// even more stuff
			group.leave()	
		}
	}
}
	
group.wait(10.0)
	
// won't be executed until callback.hell is run or 10.0 seconds pass
print("done waiting")
```
	
#Other
Thanks for checking this out :)
	
## License
[MIT](https://opensource.org/licenses/MIT)

## Contributing
Please do so! I'd love to hear your thoughts and opinions.
