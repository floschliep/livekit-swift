//
//  File.swift
//  
//
//  Created by Russell D'Sa on 12/28/20.
//

import Foundation
import CoreVideo
import CoreMedia

public class VideoFrame {
    public private(set) var timestamp: CMTime
    public private(set) var imageBuffer: CVImageBuffer
    public private(set) var orientation: VideoOrientation
    public var width: Int {
        get {
            return Int(CVImageBufferGetDisplaySize(imageBuffer).width)
        }
    }
    public var height: Int {
        get {
            return Int(CVImageBufferGetDisplaySize(imageBuffer).height)
        }
    }
    
    private static let defaultTimeScale: Int32 = 600
    
    init(timestamp: CMTime, buffer: CVImageBuffer, orientation: VideoOrientation) {
        self.timestamp = timestamp
        self.orientation = orientation
        self.imageBuffer = buffer
    }
    
    convenience init(interval: TimeInterval, buffer: CVImageBuffer, orientation: VideoOrientation) {
        let ts = CMTime(seconds: interval, preferredTimescale: VideoFrame.defaultTimeScale)
        self.init(timestamp: ts, buffer: buffer, orientation: orientation)
    }
}
