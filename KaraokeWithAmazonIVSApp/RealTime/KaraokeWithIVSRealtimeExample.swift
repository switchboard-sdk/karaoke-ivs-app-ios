//
//  KaraokeWithIVSRealtimeExample.swift
//  KaraokeWithAmazonIVSApp
//
//  Created by Balazs Banto on 2024. 03. 01..
//

import SwitchboardSuperpowered

import AmazonIVSBroadcast
import SwitchboardAmazonIVSRealTime
import SwitchboardSDK


class KaraokeWithIVSRealtimeExample: NSObject {
    let audioGraph = SBAudioGraph()
    let audioPlayerNode = SBAudioPlayerNode()
    let mixerNode = SBMixerNode()
    var ivsSinkNode: SBIVSBroadcastSinkNode!
    let autotuneNode = SBAutomaticVocalPitchCorrectionNode()
    let reverbNode = SBReverbNode()
    let flangerNode = SBFlangerNode()
    let busSplitterNode = SBBusSplitterNode()
    let audioEngine = SBAudioEngine()

    var stage: IVSStage!
    var localStreams: [IVSLocalStageStream] = []
    var ivsCustomAudioSource: IVSCustomAudioSource!
    private let deviceDiscovery = IVSDeviceDiscovery()

    override init() {
        super.init()

        ivsCustomAudioSource = deviceDiscovery.createAudioSource(withName: "custom-audio-source")
        ivsCustomAudioSource.setStatsCallback { stats in
            print(stats)
        }
        localStreams.append(IVSLocalStageStream(device: ivsCustomAudioSource))

        ivsSinkNode = SBIVSBroadcastSinkNode(customSource: ivsCustomAudioSource)

        do {
            stage = try IVSStage(token: Config.clientToken, strategy: self)

        } catch {
            print("Failed to join stage - \(error)")
        }
        
        reverbNode.isEnabled = false
        flangerNode.isEnabled = false
        autotuneNode.isEnabled = false
        
        audioGraph.addNode(audioPlayerNode)
        audioGraph.addNode(mixerNode)
        audioGraph.addNode(ivsSinkNode)
        audioGraph.addNode(reverbNode)
        audioGraph.addNode(flangerNode)
        audioGraph.addNode(autotuneNode)
        audioGraph.addNode(busSplitterNode)
        
        audioGraph.connect(audioGraph.inputNode, to: autotuneNode)
        audioGraph.connect(autotuneNode, to: reverbNode)
        audioGraph.connect(reverbNode, to: flangerNode)
        audioGraph.connect(flangerNode, to: mixerNode)
        audioGraph.connect(audioPlayerNode, to: busSplitterNode)
        audioGraph.connect(busSplitterNode, to: mixerNode)
        audioGraph.connect(mixerNode, to: ivsSinkNode)
        audioGraph.connect(busSplitterNode, to: audioGraph.outputNode)
        
        audioPlayerNode.isLoopingEnabled = true

    }
    
    func isPlaying() -> Bool {
        return audioPlayerNode.isPlaying
    }
                           
    func loadSong(songURL: String) {
        audioPlayerNode.load(songURL)
    }

    func startEngine() {
        audioEngine.microphoneEnabled = true
        audioEngine.start(audioGraph)
    }

    func stopEngine() {
        audioEngine.stop()
    }
    
    func playMusic(){
        audioPlayerNode.play()
    }
    
    func stopMusic(){
        audioPlayerNode.pause()
    }

    func startStage() {
        try? stage.join()
    }

    func stopStage() {
        stage?.leave()
    }
    
    func enableReverb(enable: Bool) {
        reverbNode.isEnabled = enable
    }

    func enableFlanger(enable: Bool) {
        flangerNode.isEnabled = enable
    }

    func enableAutomaticVocalPitchCorrection(enable: Bool) {
        autotuneNode.isEnabled = enable
    }
}

extension KaraokeWithIVSRealtimeExample: IVSStageStrategy {
    func stage(_: IVSStage, shouldSubscribeToParticipant _: IVSParticipantInfo) -> IVSStageSubscribeType {
        return IVSStageSubscribeType.none
    }

    func stage(_: IVSStage, shouldPublishParticipant _: IVSParticipantInfo) -> Bool {
        return true
    }

    func stage(_: IVSStage, streamsToPublishForParticipant _: IVSParticipantInfo) -> [IVSLocalStageStream] {
        return localStreams
    }
}
