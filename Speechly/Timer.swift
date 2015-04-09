//
//  Timer.swift
//  Speechly
//
//  Created by Vivek Ramesh on 05/04/15.
//  Copyright (c) 2015 slidenerd. All rights reserved.
//

import Foundation

class Timer{
    var timer = NSTimer();
    // the callback to be invoked everytime the timer 'ticks'
    var handler: (Int) -> ();
    //the total duration in seconds for which the timer should run to be set by the caller
    let duration: Int;
    //the amount of time in seconds elapsed so far
    var elapsedTime: Int = 0;
    
 
    /**
    :param: an integer duration specifying the total time in seconds for which the timer should run repeatedly
    :param: handler is reference to a function that takes an Integer argument representing the elapsed time allowing the implementor to process elapsed time and returns void
    */
    init(duration: Int , handler : (Int) -> ()){
        self.duration = duration;
        self.handler = handler;
    }
    
    /**
    Schedule the Timer to run every 1 second and invoke a callback method specified by 'selector' in repeating mode
    */
    func start(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTick", userInfo: nil, repeats: true);
    }
    
    /**
    invalidate the timer
    */
    func stop(){
        println("timer was invaidated from stop()")
        timer.invalidate();
    }
    
    /**
    Called everytime the timer 'ticks'. Keep track of the total time elapsed and trigger the handler to notify the implementors of the current 'tick'. If the amount of time elapsed is the same as the total duration for the timer was intended to run, stop the timer.
    */
    @objc func onTick() {
        println("onTick")
        //increment the elapsed time by 1 second
        self.elapsedTime++;
        //Notify the implementors of the updated value of elapsed time
        self.handler(elapsedTime);
        //If the amount of elapsed time in seconds is same as the total time in seconds for which this timer was intended to run, stop the timer
        if self.elapsedTime == self.duration {
            self.stop();
        }
    }
    deinit{
        println("timer was invalidated from deinit()")
        self.timer.invalidate();
    }
}