import Foundation
import SygicUIKit
import MessageUI

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
            let contact = model.contacts[indexPath.row]
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
    
    // MARK: - private
    
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
        mailComposer?.present(from: controller, recipient: mail, subject: model.title, body: "", completion: { [weak self] _ in
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
