//// SYMKDirectionController.swift
//
// Copyright (c) 2019 Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SygicMaps
import SygicUIKit


/// Controller for direction view.
public class SYMKDirectionController {
    
    // MARK: - Public Properties
    
    /// View that controller manages.
    public var view: SYMKInstructionView {
        return directionView
    }
    
    /// Actual arrow direction instruction.
    public var actualInstructionDirection: UIImageView {
        return view.actualInstructionDirection
    }
    
    /// Next arrow direction instruction.
    public var nextInstructionDirection: UIImageView {
        return view.nextInstructionDirection
    }
    
    /// Distance to actual instruction.
    public var instructionDistance: UILabel {
        return view.instructionDistance
    }
    
    /// Actual instruction text.
    public var actualInstructionText: UILabel {
        return view.actualInstructionText
    }
    
    /// Next instruction text.
    public var nextInstructionText: UILabel {
        return view.nextInstructionText
    }
    
    // MARK: - Private Properties
    
    private let directionView = SYMKDirectionView()
    private let minimumTunnelLength: UInt = 200
    private let followDistanceThreshold: UInt = 2000
    
    // MARK: - Public Methods
    
    /// Updates instructions view.
    ///
    /// - Parameter instruction: Instruction for update instruction view.
    public func update(with instruction: SYInstruction) {
        updateUI(with: instruction)
    }
    
    // MARK: - Private Methods
    
    internal func updateUI(with instruction: SYInstruction) {
        guard let primaryManeuver = instruction.primaryManeuver, primaryManeuver.type != .none else {
            clearDirectionInfo()
            return
        }
        
        var distanceInMeters = primaryManeuver.distanceToManeuver
        if let tunnelData = instruction.tunnelData, tunnelData.isInTunnel && tunnelData.remainingTunnelDistance > minimumTunnelLength {
            distanceInMeters = tunnelData.remainingTunnelDistance
        }
        
        let formattedDistanceInMeters = formattedDistance(distanceInMeters)
        
        updateDistance(formattedDistanceInMeters)
        updateDirection(from: primaryManeuver)
        updateActualInstructionText(from: primaryManeuver)
        updateNextDirection(from: instruction.secondaryManeuver)
    }
    
    internal func updateActualInstructionText(from maneuver: SYManeuver) {
        var instructionText: String
        
        if let roundaboutExit = roundaboutExitNumber(from: maneuver) {
            instructionText = "\(LS("exit")) \(roundaboutExit)"
        } else if maneuver.distanceToManeuver >= followDistanceThreshold {
            instructionText = LS("route.instructionsText.continueAlong")
        } else if let roadName = maneuver.nextRoad?.roadName, !roadName.isEmpty {
            instructionText = roadName
        } else {
            instructionText = maneuver.toTextInstruction()
        }
        
        actualInstructionText.text = instructionText
    }
    
    private func updateDirection(from maneuver: SYManeuver) {
        let bundle = Bundle(for: SYMKDirectionController.self)
        if let image = UIImage(named: maneuver.toImageName(), in: bundle, compatibleWith: nil) {
            actualInstructionDirection.image = image
        }
        
    }
    
    private func updateNextDirection(from nextManeuver: SYManeuver?) {
        guard let nextManeuver = nextManeuver, nextManeuver.type != .none else {
            animateNextInstruction(visible: false)
            return
        }
        
        let bundle = Bundle(for: SYMKDirectionController.self)
        if let image = UIImage(named: nextManeuver.toImageName(), in: bundle, compatibleWith: nil) {
            nextInstructionDirection.image = image
        }
    }
    
    private func updateDistance(_ distance: String) {
        instructionDistance.text = distance
    }
    
    internal func animateNextInstruction(visible: Bool) {
        directionView.animateNextInstruction(visible: visible)
    }
    
    private func formattedDistance(_ distance: SYDistance) -> String {
        let remainingDistance = distance.format(toShortUnits: true, andRound: true)
        return "\(remainingDistance.formattedDistance) \(remainingDistance.units)"
    }
    
    private func roundaboutExitNumber(from maneuver: SYManeuver) -> String? {
        guard let roundaboutManeuver = maneuver as? SYManeuverRoundabout, roundaboutManeuver.roundaboutExitIndex > 0 else { return nil }
        return "\(roundaboutManeuver.roundaboutExitIndex)"
    }
    
    private func clearDirectionInfo() {
        let labelToClean = [
            instructionDistance,
            actualInstructionText,
            nextInstructionText
        ]
        labelToClean.forEach { $0.text = "" }
        actualInstructionDirection.image = nil
        nextInstructionDirection.image = nil
    }
    
}
