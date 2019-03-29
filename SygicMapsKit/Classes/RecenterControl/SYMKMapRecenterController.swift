//// SYMKMapRecenterController.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the &quot;Software&quot;), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SygicUIKit


/// Recenter controller manages recenter button.
///
/// This is subclass of `SYUIMapRecenterController` in MapsKit framework, so it can conforms to `MapControl` protocol
/// and implement `update(with SYMKMapState)` method for updating recenter button based on map interaction.
public class SYMKMapRecenterController: SYUIMapRecenterController { }

extension SYMKMapRecenterController: MapControl {
    
    func update(with mapState: SYMKMapState) {
        allowedStates = mapState.recenterStates
        currentState = mapState.recenterCurrentState
    }
    
}

extension SYMKMapState {
    
    public var recenterCurrentState: SYUIRecenterState {
        if cameraMovementMode == .free {
            return .free
        } else {
            if cameraRotationMode == .attitude {
                return .lockedCompass
            } else {
                return .locked
            }
        }
    }
    
    public var recenterStates: [SYUIRecenterState] {
        switch recenterCurrentState {
        case .free:
            return [.free, .locked]
        case .locked,
             .lockedCompass:
            return [.locked, .lockedCompass]
        }
    }
    
}
