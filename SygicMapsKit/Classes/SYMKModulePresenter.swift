//// SYMKModulePresenter.swift
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
        addChild(module)
        view.addSubview(module.view)
        module.view.translatesAutoresizingMaskIntoConstraints = false
        module.view.coverWholeSuperview()
    }
    
    private func removeLastModuleFromSuperview() {
        guard let lastModule = presentedModules.last else { return }
        lastModule.view.removeFromSuperview()
        lastModule.removeFromParent()
    }
    
}
