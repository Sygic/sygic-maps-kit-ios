//// CustomAnnotation.swift
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
import SygicMaps
import SygicMapsKit


class CustomMarkerInfoExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    var customAnnotations = [SYAnnotation]()
    let reuseIdentifier = "customTapViews"
    var browseMapModule: SYMKBrowseMapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Custom marker info demo"
        
        let removeAnnotationsButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(CustomMarkerInfoExampleViewController.removeAnnotationsTapped(_:)))
        navigationItem.rightBarButtonItem = removeAnnotationsButton
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.delegate = self
        browseMap.annotationDelegate = self
        browseMap.mapSelectionMode = .all
        browseMap.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!
        browseMap.mapState.zoom = 16
        browseMapModule = browseMap
        
        presentModule(browseMap)
    }
    
    @objc private func removeAnnotationsTapped(_ sender: UIButton) {
        browseMapModule?.customMarkers = []
        customAnnotations.forEach { annotation in
            browseMapModule?.removeAnnotation(annotation)
        }
        browseMapModule?.customMarkers = nil
    }
    
}

extension CustomMarkerInfoExampleViewController: SYMKBrowseMapViewControllerDelegate {
    
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol) {
        guard let data = data as? SYMKPoiData else { return }
        let customAnnotation = DataAnnotation(data: data)
        customAnnotations.append(customAnnotation)
        browseController.addAnnotation(customAnnotation)
        let pin = SYMapMarker(with: data)
        var pins = browseController.customMarkers ?? [SYMapMarker]()
        pins.append(pin)
        browseController.customMarkers = pins
    }
    
}

extension CustomMarkerInfoExampleViewController: SYMKBrowserMapViewControllerAnnotationDelegate {
    
    func browseMapController(_ browseController: SYMKBrowseMapViewController, wantsViewFor annotation: SYAnnotation) -> SYAnnotationView {
        let annotationView: DataAnnotationView
        
        if let dequeueView = browseController.dequeueReusableAnnotation(for: reuseIdentifier), let dataAnnotationView = dequeueView as? DataAnnotationView {
            annotationView = dataAnnotationView
        } else {
            annotationView = DataAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.accessibilityIdentifier = "DataAnnotation"
        }
        
        annotationView.anchorPoint = CGPoint(x: 0.5, y: 2)
        annotationView.firstText = "\(annotation.coordinate.latitude)"
        annotationView.secondText = "\(annotation.coordinate.longitude)"
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(customViewTapped)))
        
        return annotationView
    }
    
    @objc func customViewTapped() {
        print("Custom View Tapped")
    }
    
}
