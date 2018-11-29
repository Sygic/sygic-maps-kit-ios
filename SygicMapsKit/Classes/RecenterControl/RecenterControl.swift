import Foundation
import SygicMaps
import SygicUIKit

public protocol SYMKMapRecenterDelegate: class {
    func didChangeRecenterButtonState(button: SYUIActionButton, state: SYMKMapRecenterController.state)
}

public class SYMKMapRecenterController: NSObject {
    public enum state {
        case free
        case locked
        case lockedCompass
    }
    
    public var button = SYUIActionButton()
    public var allowedStates = [state.free, state.locked, state.lockedCompass]
    
    public var currentState = state.free {
        didSet {
            refreshIcon()
            if let delegate = delegate, oldValue != currentState {
                delegate.didChangeRecenterButtonState(button: button, state: currentState)
            }
        }
    }
    public weak var delegate: SYMKMapRecenterDelegate?
    
    public override init() {
        super.init()
        button.style = .secondary
        button.addTarget(self, action: #selector(SYMKMapRecenterController.didTapButton), for: .touchUpInside)
        refreshIcon()
    }
    
    @objc func didTapButton() {
        if allowedStates.count == 0 { return }
        guard var stateIndex = allowedStates.firstIndex(of: currentState) else { return }
        stateIndex += 1
        
        if stateIndex >= allowedStates.count {
            stateIndex = 0
        }

        currentState = allowedStates[stateIndex]
    }
    
    private func refreshIcon() {
        switch currentState {
        case .free:
            button.icon = SygicIcon.positionIos
        case .locked:
            button.icon = SygicIcon.positionLockIos
        case .lockedCompass:
            button.icon = SygicIcon.positionLockCompassIos
        }
    }
}
