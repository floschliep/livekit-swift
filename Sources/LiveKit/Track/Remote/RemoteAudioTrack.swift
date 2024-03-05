/*
 * Copyright 2024 LiveKit
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

@_implementationOnly import LiveKitWebRTC

@objc
public class RemoteAudioTrack: Track, RemoteTrack, AudioTrack {
    /// Volume with range 0.0 - 1.0
    public var volume: Double {
        get {
            guard let audioTrack = mediaTrack as? LKRTCAudioTrack else { return 0 }
            return audioTrack.source.volume / 10
        }
        set {
            guard let audioTrack = mediaTrack as? LKRTCAudioTrack else { return }
            audioTrack.source.volume = newValue * 10
        }
    }
    
    private var renderAdapters = Set<AudioRendererAdapter>()

    init(name: String,
         source: Track.Source,
         track: LKRTCMediaStreamTrack,
         reportStatistics: Bool)
    {
        super.init(name: name,
                   kind: .audio,
                   source: source,
                   track: track,
                   reportStatistics: reportStatistics)
    }

    public func add(audioRenderer: AudioRenderer) {
        guard let audioTrack = mediaTrack as? LKRTCAudioTrack else { return }
        
        let wrapper = AudioRendererAdapter(target: audioRenderer)
        wrapper.onTargetDeallocated = { [weak self] adapter in
            self?.removeAdapter(adapter)
        }
        renderAdapters.insert(wrapper)
        audioTrack.add(wrapper)
    }

    public func remove(audioRenderer: AudioRenderer) {
        guard let adapter = renderAdapters.first(where: { $0.target === audioRenderer }) else {
            return
        }
        removeAdapter(adapter)
    }

    // MARK: - Internal

    override func startCapture() async throws {
        AudioManager.shared.trackDidStart(.remote)
    }

    override func stopCapture() async throws {
        AudioManager.shared.trackDidStop(.remote)
    }
    
    private func removeAdapter(_ adapter: AudioRendererAdapter) {
        renderAdapters.remove(adapter)
        guard let audioTrack = mediaTrack as? LKRTCAudioTrack else { return }
        audioTrack.remove(adapter)
    }
}
