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
            recordButton.setTitle("Record", forState: UIControlState.Normal)
            audioRecorder?.pause()
        }
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        stopButton.enabled = false
        playButton.enabled = true
        recordButton.enabled = true
        recordButton.setTitle("Record", forState: UIControlState.Normal)
        timer.invalidate()
        recordTimer.text = "00:00:00"
        
        if audioPlayer?.playing == true{
            audioPlayer?.stop()
        } else {
            audioRecorder?.stop()
        }
        
        
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        if audioRecorder?.recording == false {
            stopButton.enabled = true
            recordButton.enabled = false
            
            var error: NSError?
            
            audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder?.url, error: &error)
            
            audioPlayer?.delegate = self
            
            if let err = error {
                println("audioPlayer error: \(err.localizedDescription)")
            } else {
                audioPlayer?.play()
            }
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

