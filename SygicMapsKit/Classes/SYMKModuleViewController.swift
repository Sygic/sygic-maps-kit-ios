//// SYMKModuleViewController.swift
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


/// Module view controller. Subclass of `UIViewController` that contains Sygic Map object and handle
/// SDK initialization. It contains `SYMKMapState` object that stores map view and state of map.
public class SYMKModuleViewController: UIViewController {
    
    /// State of map in module.
    ///
    /// Pass map state between multiple modules. So you can share state of map and mapView object.
    /// You can pass state by reference or create copy with `SYMKMapState` `copy()` method and
    /// pass new instance. So you just change state of new module.
    public var mapState: SYMKMapState = SYMKMapState()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        SYMKSdkManager.shared.initializeIfNeeded { [weak self] success in
            if success {
                self?.sygicSDKInitialized()
            } else {
                self?.sygicSDKFailure()
            }
        }
    }
    
    /// Method called after Sygic SDK is succesfully initialized.
    ///
    /// Override this method in subclass. Use this override like `viewDidLoad`
    /// for module, because `viewDidLoad` is used for SDK initialize.
    internal func sygicSDKInitialized() { }
    
    /// Method called after Sygic SDK initialization fails.
    ///
    /// Override this method in subclass for custom behaviour.
    internal func sygicSDKFailure() {
        let alert = UIAlertController(title: "Error", message: "Error during SDK initialization", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
}
