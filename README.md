# Sprint
Swift Grand Central Dispatch made easier

## Overview
Sprint contains 3 types
- `Sprint` a dispatch_block_t wrapper
- `SprintQueue` a dispatch_queue_t wrapper
- `SprintGroup` a dispatch_group_t wrapper

## Usage
`SprintQueue` is an enum whose value is related to the Quality of Service Class (QoS) it is running on
Values are:
- `Main`
- `UserInteractive`
- `UserInitiated`
- `Utility`
- `Background`
- `Custom(dispatch_queue_t)` serial or concurrent created through SprintQueue.customSerial(label: String) 
  and SprintQueue.customConcurrent(label: String)
  
    let backgroundQueue: SprintQueue = .Background
    backgroundQueue.async {
      // background work
    }.finished {
      // background work is finished
    }.finished(.Main) {
      // this finish block will be run on the Main thread
      // finish can be chained as many times as you want
    }
