import UIKit

public protocol SYMKModulePresenter: class {
    var presentedModules: [SYMKModuleViewController] { get set }
    
    func presentModule(_ viewController: SYMKModuleViewController)
    func dismissModule()
}

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
