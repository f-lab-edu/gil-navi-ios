//
//  RouteMapView.swift
//  GIL
//
//  Created by 송우진 on 5/8/24.
//

import UIKit
import MapKit

final class RouteMapView: UIView {
    let backButton = UIButton()
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        return mapView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
extension RouteMapView {
    private func setupUI() {
        addSubviews()
        setupComponents()
    }
    
    private func addSubviews() {
        [mapView, backButton].forEach({ addSubview($0) })
    }
    
    private func setupComponents() {
        setupMapView()
        setupBackButton()
    }
    
    private func setupMapView() {
        mapView.applyConstraints(to: self, attributes: [.top, .bottom, .leading, .trailing])
    }
    
    private func setupBackButton() {
        backButton
            .configureNavigationStyle(type: .back)
            .setBackgroundColor(.white, for: .normal)
            .setShadow(color: .black, offset: CGSize(width: 0, height: 1), radius: 3, opacity: 1)
            .setLayer(cornerRadius: 20)
            .top(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)
            .left(equalTo: leadingAnchor, constant: 16)
            .size(CGSize(width: 40, height: 40))
    }
}
