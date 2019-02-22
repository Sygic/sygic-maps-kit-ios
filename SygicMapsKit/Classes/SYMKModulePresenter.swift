import UIKit


/// Module presenter protocol define methods for presenting modules.
///
/// Apply this presenter protocol to `UIViewController` that manage modules and their presenting.
/// Think of it as navigation controller for modules.
/// Basically, in `viewDidLoad` method of `UIViewController`, initialize module and present it
/// with `presentModule(SYMKModuleViewController)` method.
public protocol SYMKModulePresenter: class {
    /// Modules that are actually presented.
    ///
    /// This is only variable you must implement, when using this protocol. All other variables and methods
    /// have default implementation. You must implement this, because stored variables can't be
    /// implemented in default implementation (extension).
    var presentedModules: [SYMKModuleViewController] { get set }
    
    /// Present module view controller.
    ///
    /// - Parameter viewController: Module view controller to present.
    func presentModule(_ viewController: SYMKModuleViewController)
    /// Dismiss the latest module view controller presented.
    func dismissModule()
}

// MARK: - Default implementation of `presentModule` and `dismissModule` methods.

public extension SYMKModulePresenter where Self: UIViewController {
    
    public func presentModule(_ viewController: SYMKModuleViewController) {
        removeLastModuleFromSuperview()
        presentedModules.append(viewController)
        addModuleAsSubview(viewController)
    }
    
    public func dismissModule() {
        removeLastModuleFromSuperview()
        _ = presentedModules.popLast()
        
        if let lastModule = presentedModules.last {
            addModuleAsSubview(lastModule)
        }
    }
    
    private func addModuleAsSubview(_ module: SYMKModuleViewController) {
        addChildViewController(module)
        view.addSubview(module.view)
        module.view.translatesAutoresizingMaskIntoConstraints = false
        module.view.coverWholeSuperview()
    }
    
    private func removeLastModuleFromSuperview() {
        guard let lastModule = presentedModules.last else { return }
        lastModule.view.removeFromSuperview()
        lastModule.removeFromParentViewController()
    }
    
}
