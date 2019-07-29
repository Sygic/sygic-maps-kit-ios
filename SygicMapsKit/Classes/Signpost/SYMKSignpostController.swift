//// SYMKSignpostController.swift
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


/// Controller for signpost view.
public class SYMKSignpostController: SYMKDirectionController {
    
    // MARK: - Public Properties
    
    /// View that controller manages.
    public override var view: SYMKInstructionView {
        return signpostView
    }
    
    // MARK: - Private Properties

    private let signpostView = SYMKSignpostView()
    private var latestUpdate: (instruction: SYInstruction?, signposts: [SYSignpost]?) = (instruction: nil, signposts: nil) {
        didSet {
            if let instruction = latestUpdate.instruction {
                updateUI(with: instruction)
            }
            if let signposts = latestUpdate.signposts {
                updateUI(with: signposts)
            }
        }
    }
    
    // MARK: - Public Methods
    
    public override func update(with instruction: SYInstruction) {
        latestUpdate.instruction = instruction
    }
    
    /// Updates signpost.
    ///
    /// - Parameter signposts: Signposts on the actual road.
    public func update(with signposts: [SYSignpost]) {
        latestUpdate.signposts = signposts
    }
    
    // MARK: - Private Methods

    private func updateUI(with signposts: [SYSignpost]) {
        guard !signposts.isEmpty else {
            clearSignpostInfo()
            return
        }
        let prioritySorted = signposts.sorted { $0.priority > $1.priority }
        let signpostWithHighestPriorityOnRoute = prioritySorted.first { $0.isOnRoute }
        guard let signpost = signpostWithHighestPriorityOnRoute else { return }
        
        var instructionText: String?
        var titles = [String]()
        var routeNumbers = [SYRouteNumberFormat]()
        var exitNames = [String]()
        var pictograms = [String]()
        
        for element in signpost.elements {
            switch element.type {
            case .placeName, .streetName, .otherDestination:
                if let text = element.text {
                    titles.append(text)
                }
            case .routeNumber:
                if let format = element.numberFormat {
                    routeNumbers.append(format)
                }
            case .exitName, .exitNumber:
                if let exitName = element.text {
                    exitNames.append(exitName)
                }
            case .pictogram:
                pictograms.append(element.pictogram.toSymbol())
                break
            case .lineBreak:
                break
            }
        }
        
        let exit = exitNames.joined(separator: " ")
        if !exit.isEmpty {
            instructionText = "\(LS("exit")) \(exit)"
        } else if !titles.isEmpty {
            instructionText = titles.joined(separator: ", ")
        }
        
        if let instructionText = instructionText {
            actualInstructionText.text = instructionText
        }
        
        pictograms = Array(pictograms.prefix(signpostView.maxSymbols))
        routeNumbers = Array(routeNumbers.prefix(signpostView.maxSymbols - pictograms.count))
        
        signpostView.updateRouteNumbers(with: routeNumbers)
        signpostView.updatePictograms(with: pictograms)
    }
    
    override func animateNextInstruction(visible: Bool) {
        signpostView.animateNextInstruction(visible: visible)
    }
    
    private func clearSignpostInfo() {
        signpostView.updateRouteNumbers(with: [])
        signpostView.updatePictograms(with: [])
    }
    
    private func roundaboutExitNumber(from maneuver: SYManeuver) -> String? {
        guard let roundaboutManeuver = maneuver as? SYManeuverRoundabout, roundaboutManeuver.roundaboutExitIndex > 0 else { return nil }
        return "\(roundaboutManeuver.roundaboutExitIndex)"
    }
    
}
