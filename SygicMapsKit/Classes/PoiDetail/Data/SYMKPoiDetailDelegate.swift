//// SYMKPoiDetailDelegate.swift
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


/// Provides implementation of SYUIPoiDetailDelegate
public class SYMKPoiDetailDelegate: SYUIPoiDetailDelegate {
    
    let model: SYMKPoiDetailModel
    weak var controller: UIViewController?
    
    private var mailComposer: SYUIMailComposer?
    
    init(with model: SYMKPoiDetailModel, controller: UIViewController) {
        self.model = model
        self.controller = controller
    }
    
    public func poiDetailDidPressActionButton(at index: Int) {
        // no default action
    }
    
    public func poiDetailDidSelectCell(at indexPath: IndexPath) {
        guard let section = SYUIPoiDetailSectionType(rawValue: indexPath.section) else { return }
        switch section {
        case .contactInfo:
            let contact = model.poiDetailContacts[indexPath.row]
            switch contact {
            case .phone:
                call()
            case .email:
                sendMail()
            case .website:
                openWebpage()
            }
        default:
            break
        }
    }
    
    // MARK: - Private methods
    
    private func call() {
        guard var urlString = model.phone else { return }
        if urlString.range(of: "tel:") == nil {
            urlString = String(format: "tel://%@", urlString)
        }
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func sendMail() {
        guard let mail = model.email, let controller = controller, MFMailComposeViewController.canSendMail() else { return }
        mailComposer = SYUIMailComposer()
        mailComposer?.present(from: controller, recipient: mail, subject: model.poiDetailTitle, body: "", completion: { [weak self] _ in
            self?.mailComposer?.dismiss(animated: true, completion: nil)
            self?.mailComposer = nil
        })
    }
    
    private func openWebpage() {
        guard var urlString = model.website else { return }
        if urlString.range(of: "http:") == nil {
            urlString = String(format: "http://%@", urlString)
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
