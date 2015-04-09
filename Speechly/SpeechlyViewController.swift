//
//  ViewController.swift
//  Speechly
//
//  Created by Vivek Ramesh on 05/04/15.
//  Copyright (c) 2015 slidenerd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    //the TextField where the user will enter the countdown time in mm:ss format
    var textTime : UITextField?
    @IBOutlet weak var toggleTimer: UISwitch!
    @IBOutlet weak var labelTime: UILabel!
    var timer:Timer!;
    //Called when the toggle button switches between on and off
    @IBAction func onCheckedChange(sender: AnyObject) {
        if toggleTimer.on {
            //if the switch is on, let the user enter the time for which countdown should run
            promptUser()
        }
        else{
            timer.stop()
            labelTime!.text = "00:00"
            println("timer is off")
        }
    }
    
    /**
    This method is triggered after the user hits 'Set' to set a countdown timer to run, create a timer, update the label to indicate the time set by the user in the dialog
    :param: an action indicating the choice taken by the user
    */
    private func handleSetAction (action: UIAlertAction!) -> (){
        if action.title == "Set" {
            //0
            labelTime.text = textTime!.text;
            //convert the user entered time from 'mm:ss' format to seconds
            let duration = Utils.getTotalDurationInSeconds(textTimeInMinutesAndSeconds: textTime!.text);
            //Initialize the timer to run for the amount of seconds specified in the above step and update the label with the amount of remaining time
            timer = Timer(duration: duration ){
                //the handler or callback which is triggered each time the timer 'ticks'
                (elapsedTime: Int) -> () in
                println("handler called")
                //remaining time in seconds = total duration in seconds - elapsed time in seconds
                let difference = duration - elapsedTime;
                if difference == 0 {
                    self.toggleTimer!.setOn(false, animated: true);
                }
                self.labelTime.text = Utils.getDurationInMinutesAndSeconds(difference)
            }
            timer.start();
        }
    }
    /**
    Show the Alert Controller to the user and ask him/her to enter time
    */
    private func promptUser(){
        var alertController = UIAlertController(title: "Countdown From", message: nil, preferredStyle: .Alert);
        
        //add a textfield to the AlertController that can take user input
        alertController.addTextFieldWithConfigurationHandler{
            //Notice the trailing closure used to specify the TextField
            (textField) -> () in
            //store a reference to the textField containing the time entered by the user in 'mm:ss' format provided in the closure block so that we can access the contents of the field later
            self.textTime = textField;
            //specify that this class acts as the delegate to receive changes in the contents of the textfield event
            self.textTime?.delegate = self;
            textField.placeholder = "05:30"
        }
        
        //create an action which lets the user 'Set' the time and use the specified handler to process if user selects this action
        var actionSet = UIAlertAction(title: "Set", style: UIAlertActionStyle.Default, handler: handleSetAction)
        var actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            //Notice the trailing closure that handles the action when user chooses 'Cancel'
            (actionCancel) -> () in
            //turn the switch off if the user cancels the dialog
            self.toggleTimer.setOn(false, animated: true)
        }
        alertController.addAction(actionSet)
        alertController.addAction(actionCancel)
        presentViewController(alertController, animated: true, completion: nil);
    }
    /**
    Called each time the user types some character, determine if the whole String is valid or not in terms of its content and length
    */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //Assume by default that user input is valid for time
        var isValidInput : Bool = true;
        //the String that will represent the time entered by the user if the user input for time is not modified
        let prospectiveText = (textTime!.text  as NSString).stringByReplacingCharactersInRange(range, withString: string);
        //if the user actually typed a character for replacementString, then only process anything , else nothing
        if textField == textTime && count(string) > 0 {
            //The set of all characters except the ones represented below by NSCharacterSet
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789:") . invertedSet
            //for all the characters which are not numbers and : check if any of them exist in the input string, if yes, return false which will prevent the user from entering that value, if no then return true to indicate the user can enter such a value
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil) == nil;
            //let the user enter anywhere upto 5 characters, upto is important because strictly 5 characters block the user from entering any input at all
            let isOfAllowedLength = count(prospectiveText) <= 5;
            //the input is valid if the replacement string does not contain any non numeric characters and at the same time has upto 5 characters
            isValidInput = replacementStringIsLegal && isOfAllowedLength;
        }
        return isValidInput;
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

