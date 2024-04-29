//  KaraokeWithIVSRealtimeViewController.swift
//  KaraokeWithAmazonIVSApp
//
//  Created by Balazs Banto on 2024. 03. 01..
//

import UIKit

class KaraokeWithIVSRealtimeViewController: UIViewController {

    let audioSystem = KaraokeWithIVSRealtimeExample()
    var isStreaming = false

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var streamButton: UIButton!
    
    @IBOutlet weak var reverbSwitch: UISwitch!
    @IBOutlet weak var flangerSwitch: UISwitch!
    @IBOutlet weak var avpcSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        startButton.setTitle("Start Music", for: .normal)

        audioSystem.loadSong(songURL: Bundle.main.url(forResource: "House_of_the_Rising_Sun", withExtension: "mp3")!.absoluteString)
        
        reverbSwitch.isOn = audioSystem.reverbNode.isEnabled
        flangerSwitch.isOn = audioSystem.flangerNode.isEnabled
        avpcSwitch.isOn = audioSystem.autotuneNode.isEnabled
        
        audioSystem.startEngine()
    }

    deinit {
        audioSystem.stopEngine()
    }

    @IBAction func startTapped(_ sender: Any) {
        if audioSystem.isPlaying() {
            startButton.setTitle("Start Music", for: .normal)
            audioSystem.stopMusic()
        } else {
            startButton.setTitle("Stop Music", for: .normal)
            audioSystem.playMusic()
        }
    }
    
    @IBAction func streamTapped(_ sender: Any) {
        if isStreaming {
            isStreaming = false
            streamButton.setTitle("Start Streaming", for: .normal)
            audioSystem.stopStage()
        } else {
            isStreaming = true
            streamButton.setTitle("Stop Streaming", for: .normal)
            audioSystem.startStage()
        }
    }
    
    @IBAction func reverbSwitched(_ sender: Any) {
        audioSystem.enableReverb(enable: reverbSwitch.isOn)
    }
    
    @IBAction func flangerSwitched(_ sender: Any) {
        audioSystem.enableFlanger(enable: flangerSwitch.isOn)
    }
    @IBAction func avpcSwitched(_ sender: Any) {
        audioSystem.enableAutomaticVocalPitchCorrection(enable: avpcSwitch.isOn)
    }
    
}
