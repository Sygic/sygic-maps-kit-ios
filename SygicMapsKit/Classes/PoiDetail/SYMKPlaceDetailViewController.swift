//// SYMKPoiDetailViewController.swift
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

import Foundation
import SygicUIKit
import MessageUI


public class SYMKPlaceDetailViewController: UIViewController {
    
    // MARK: - Public properties
    
    public var model: SYMKPlaceDetailModel? {
        didSet {
            updateViewData()
        }
    }
    
    public var placeView: SYUIBubbleView {
        return view as! SYUIBubbleView
    }
    
    // MARK: - Private properties
    
    private var mailComposer: SYUIMailComposer?
    
    // MARK: - Public methods
    
    /// Default initializer with data model structure
    /// - Parameter dataModel: place data. If nil, loading indicator is shown
    public required init(with dataModel: SYMKPlaceDetailModel?) {
        self.model = dataModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let bubbleView = SYUIBubbleView()
        view = bubbleView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        updateViewData()
    }
    
    /// Presents placeDetail controller as childViewController from presentingViewController
    ///
    /// - Parameters:
    ///   - presentingViewController: presenting view controller (parentViewController)
    ///   - landscapeLayout: indicates if placeDetail view will use full width in compact and regular layouts
    ///   - animated: simple animation for smooth presentation
    ///   - completion: completion block called when presenting animations are finished
    public func presentPlaceDetailAsChildViewController(to presentingViewController: UIViewController, landscapeLayout: Bool, animated: Bool, completion: ((_ finished: Bool)->())?) {
        presentingViewController.addChild(self)
        placeView.addToView(presentingViewController.view, landscapeLayout: landscapeLayout, animated: animated) { finished in
            completion?(finished)
        }
    }
    
    /// Dismiss poiDetail controller and removes him from parentViewController
    ///
    /// - Parameter completion: completion block
    public func dismissPoiDetail(completion: ((_ finished: Bool)->())?) {
        view.removeFromSuperview()
        removeFromParent()
        completion?(true)
    }
    
    // MARK: - Private methods
    
    private func updateViewData() {
        placeView.headerStackView.removeAll()
        guard let model = model else {
            placeView.addHeader(SYUIBubbleLoadingHeader())
            return
        }
        placeView.addHeader(with: model.poiDetailTitle, model.poiDetailSubtitle)
        if model.poiDetailContacts.count > 0 {
            addContactButton(for: .website(model.website ?? ""))
            addContactButton(for: .phone(model.phone ?? ""))
            addContactButton(for: .email(model.email ?? ""))
        }
        if let icon = SYUIIcon.pointOnMap {
            placeView.addContent(with: icon, title: LS("GPS coordinates"), subtitle: model.location.string)
        }
        for buttonView in placeView.buttonsContainer.arrangedSubviews {
            if let button = buttonView as? SYUIActionButton {
                button.isEnabled = true
            }
        }
    }
    
    private func addContactButton(for contact: SYMKPoiDetailContact) {
        let valueString = contact.value
        placeView.addContentActionButton(title: contact.title, icon: contact.iconImage, enabled: !valueString.isEmpty) { [unowned self] _ in
            switch contact {
            case .phone:
                self.call()
            case .email:
                self.sendMail()
            case .website:
                self.openWebpage()
            }
        }
    }
    
    private func call() {
        guard var urlString = model?.phone else { return }
        if urlString.range(of: "tel:") == nil {
            urlString = String(format: "tel://%@", urlString)
        }
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func sendMail() {
        guard let model = model, let mail = model.email, MFMailComposeViewController.canSendMail() else { return }
        mailComposer = SYUIMailComposer()
        mailComposer?.present(from: self, recipient: mail, subject: model.poiDetailTitle, body: "", completion: { [weak self] _ in
            self?.mailComposer?.dismiss(animated: true, completion: nil)
            self?.mailComposer = nil
        })
    }
    
    private func openWebpage() {
        guard var urlString = model?.website else { return }
        if urlString.range(of: "http:") == nil {
            urlString = String(format: "http://%@", urlString)
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
