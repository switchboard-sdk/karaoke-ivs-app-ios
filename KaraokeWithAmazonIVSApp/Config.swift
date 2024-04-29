//
//  Config.swift
//  KaraokeWithAmazonIVSApp
//
//  Created by Iván Nádor on 2023. 08. 14..
//

import Foundation
import SwitchboardSDK

// To get your own cliendId and clientSecret please contact sales@synervoz.com
struct Config {
    static let clientID = "ivs-karaoke-sample-app"
    static let clientSecret = "33ecdd620e70252048be5b211c128fea5e78a546"
    static let superpoweredLicenseKey = "ExampleLicenseKey-WillExpire-OnNextUpdate"
    static let clientToken = ""

    static var recordingFilePath: String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].absoluteString + "recording.wav"
    }

    static var mixedFilePath: String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].absoluteString + "mix.wav"
    }

    static let fileFormat: SBCodec = .wav
}
