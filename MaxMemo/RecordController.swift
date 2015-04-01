//
//  ViewController.swift
//  MaxMemo
//
//  Created by Aleksandar Dimitrov on 3/27/15.
//  Copyright (c) 2015 Aleksandar Dimitrov. All rights reserved.
//

import UIKit
import AVFoundation

class RecordController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    @IBOutlet var playButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var recordTimer: UILabel!
    var timer = NSTimer()
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    
    var recordSettings = [
        AVFormatIDKey: kAudioFormatAppleLossless,
        AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.enabled = false
        stopButton.enabled = false
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        let soundFilePath = docsDir.stringByAppendingPathComponent("sound.caf")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        
        var error: NSError?
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord,error: &error)
        
        if let err = error {
            println("audioSession error: \(err.localizedDescription)")
        }
        
        audioRecorder = AVAudioRecorder(URL: soundFileURL, settings: recordSettings, error: &error)
        
        if let err = error {
            println("audioSession error: \(err.localizedDescription)")
        } else {
            audioRecorder?.prepareToRecord()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func recordPauseAudio(sender: AnyObject) {
        if audioRecorder?.recording == false {
            recordButton.setTitle("Pause", forState: UIControlState.Normal)
            playButton.enabled = false
            stopButton.enabled = true
            audioRecorder?.record()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                target:self,
                selector:"updateRecordTimer:",
                userInfo:nil,
                repeats:true)
        } else {
            playButton.enabled = true
            recordButton.setTitle("Record", forState: UIControlState.Normal)
            audioRecorder?.pause()
            var error: NSError?
            audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder?.url, error: &error)
            audioPlayer?.delegate = self
        }
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        stopButton.enabled = false
        playButton.enabled = false
        recordButton.enabled = true
        recordButton.setTitle("Record", forState: UIControlState.Normal)
        timer.invalidate()
        recordTimer.text = "00:00:00"
        
        if audioPlayer?.playing == true{
            audioPlayer?.stop()
        }
            audioRecorder?.stop()
            self.saveRecord()
        
    }
    
    func saveRecord() {
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Save Recording",
            message: "Enter record name below",
            preferredStyle: .Alert)
        
        alertController!.addTextFieldWithConfigurationHandler({(textField: UITextField!) in})
        
        let action = UIAlertAction(title: "Save",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields{
                    let theTextFields = textFields as [UITextField]
                    let enteredText = theTextFields[0].text
                    
                }
        })
        
        alertController!.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in }))
        
        alertController?.addAction(action)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
    }
    
    
    @IBAction func playAudio(sender: AnyObject) {
        println("playing \(audioPlayer?.playing)")
        if audioPlayer?.playing == false {
            playButton.setTitle("Pause", forState: UIControlState.Normal)
            stopButton.enabled = true
            recordButton.enabled = false
            
            audioPlayer?.play()
            
        } else {
            playButton.setTitle("Play", forState: UIControlState.Normal)
            audioPlayer?.pause()
        }
    }
    
    func updateRecordTimer(timer:NSTimer) {
        if audioRecorder.recording{
            let min:Int = Int(audioRecorder.currentTime / 60)
            let sec:Int = Int(audioRecorder.currentTime % 60)
            let ms:Int = Int((audioRecorder.currentTime % 1) * 100)
            recordTimer.text = NSString(format: "%0.2d:%0.2d:%0.2d",min,sec,ms)
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        recordButton.enabled = true
        stopButton.enabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println("Audio Record Encode Error")
    }
}

