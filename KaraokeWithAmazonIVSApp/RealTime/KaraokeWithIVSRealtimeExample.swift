//
//  KaraokeWithIVSRealtimeExample.swift
//  KaraokeWithAmazonIVSApp
//
//  Created by Balazs Banto on 2024. 03. 01..
//

import SwitchboardSDK
import SwitchboardSuperpowered
import AmazonIVSBroadcast
import SwitchboardAmazonIVSRealTime

class KaraokeWithIVSRealtimeExample: NSObject {
    private var engineID: String!
    private var _isPlaying = false
    private(set) var isReverbEnabled = false
    private(set) var isFlangerEnabled = false
    private(set) var isAutotuneEnabled = false

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

        do {
            stage = try IVSStage(token: Config.clientToken, strategy: self)
        } catch {
            print("Failed to join stage - \(error)")
        }

        guard let path = Bundle.main.path(forResource: "AudioGraph", ofType: "json"),
              let json = try? String(contentsOfFile: path),
              let data = json.data(using: .utf8),
              let config = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { fatalError("AudioGraph.json missing or invalid") }

        let result = Switchboard.createEngine(withConfig: config)
        engineID = result.value! as String

        let ptr = Int64(bitPattern: UInt64(UInt(bitPattern: Unmanaged.passUnretained(ivsCustomAudioSource).toOpaque())))
        Switchboard.setValue(ptr, forKey: "customAudioSource", onObject: "ivsSinkNode")
    }

    func isPlaying() -> Bool {
        return _isPlaying
    }

    func loadSong(songURL: String) {
        let path = URL(string: songURL)?.path ?? songURL
        Switchboard.callAction(withObject: "audioPlayerNode", actionName: "open", params: ["path": path])
    }

    func startEngine() {
        Switchboard.callAction(withObject: engineID, actionName: "start", params: nil)
    }

    func stopEngine() {
        Switchboard.callAction(withObject: engineID, actionName: "stop", params: nil)
    }

    func playMusic() {
        Switchboard.callAction(withObject: "audioPlayerNode", actionName: "play", params: nil)
        _isPlaying = true
    }

    func stopMusic() {
        Switchboard.callAction(withObject: "audioPlayerNode", actionName: "pause", params: nil)
        _isPlaying = false
    }

    func startStage() {
        try? stage.join()
    }

    func stopStage() {
        stage?.leave()
    }

    func enableReverb(enable: Bool) {
        Switchboard.setValue(enable, forKey: "enabled", onObject: "reverbNode")
        isReverbEnabled = enable
    }

    func enableFlanger(enable: Bool) {
        Switchboard.setValue(enable, forKey: "enabled", onObject: "flangerNode")
        isFlangerEnabled = enable
    }

    func enableAutomaticVocalPitchCorrection(enable: Bool) {
        Switchboard.setValue(enable, forKey: "enabled", onObject: "autotuneNode")
        isAutotuneEnabled = enable
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
