//
//  File.swift
//  
//
//  Created by Russell D'Sa on 11/8/20.
//

import Foundation

public protocol RoomDelegate {
    func didConnect(room: Room)
    func didDisconnect(room: Room, error: Error?)
    func didFailToConnect(room: Room, error: Error)
    func isReconnecting(room: Room, error: Error)
    func didReconnect(room: Room)
    func participantDidConnect(room: Room, participant: Participant)
    func participantDidDisconnect(room: Room, participant: Participant)
    func didStartRecording(room: Room)
    func didStopRecording(room: Room)
    func dominantSpeakerDidChange(room: Room, participant: Participant)
}
