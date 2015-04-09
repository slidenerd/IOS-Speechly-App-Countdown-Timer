//
//  Utils.swift
//  Speechly
//
//  Created by Vivek Ramesh on 06/04/15.
//  Copyright (c) 2015 slidenerd. All rights reserved.
//

import Foundation
class Utils{
    /**
    Accepts ti
    :param: a string time of the format 'mm:ss'
    */
    class func getTotalDurationInSeconds(textTimeInMinutesAndSeconds textTime : String) -> Int {
        var durationInSeconds : Int = 0;
        //find the position of : in a sample time string like '01:45' its expected to be at position 2
        let indexOfColon : String.Index? = find(textTime, ":");
        //if the user actually entered : while adding time, process the input, else do nothing
        if let index = indexOfColon {
            let minutes : Int? = textTime.substringToIndex(indexOfColon!).toInt();
            let seconds : Int? = textTime.substringFromIndex(indexOfColon!.successor()).toInt();
            durationInSeconds = minutes! * 60 + seconds!;
        }
        return durationInSeconds;
    }
    class func getDurationInMinutesAndSeconds(duration: Int) -> String {
        let minutes = duration/60;
        let seconds = duration % 60;
        var duration = "";
        if minutes < 10 {
            duration = "0\(minutes)";
        }
        else{
            duration="\(minutes)";
        }
        if seconds < 10{
            duration += ":0\(seconds)"
        }
        else{
            duration += ":\(seconds)";
        }
        return duration;
    }
}