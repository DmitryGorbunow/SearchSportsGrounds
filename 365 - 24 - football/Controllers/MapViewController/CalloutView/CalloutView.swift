//
//  CalloutView.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/14/23.
//

import UIKit
import CoreLocation

class CalloutView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var calloutImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openingHoursLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var buildRouteButton: UIButton!
    
    var place: Place?
    var distance: String?
    
    var buildRoute:(() -> ())?
    var showOverlay:((Place, String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
        self.setupViews()
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: CalloutView.self)
        if let viewToAdd = bundle.loadNibNamed("CalloutView", owner: self, options: nil), let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.corneredRadius(radius: 30, corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
            contentView.setShadow()
        }
    }
    
    private func setupViews() {
        calloutImageView.corneredRadius(radius: 20)
        buildRouteButton.corneredRadius(radius: 25)
        buildRouteButton.setShadow()
        
        self.calloutImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                
        let width = self.bounds.width
        let height = self.bounds.height
        let sHeight:CGFloat = 300
        let shadow = UIColor.black.withAlphaComponent(0.5).cgColor

        // Add gradient bar for image on top
        let topImageGradient = CAGradientLayer()
        topImageGradient.frame = CGRect(x: 0, y: 0, width: width, height: sHeight)
        topImageGradient.colors = [shadow, UIColor.clear.cgColor]
        calloutImageView.layer.insertSublayer(topImageGradient, at: 0)

        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        calloutImageView.layer.insertSublayer(bottomImageGradient, at: 0)
    
    }
    
    // MARK: - Public funcs
    func configure(coordinate: CLLocationDegrees) {
        if let place = DataManager.shared.places.first(where: { $0.coordinate.latitude == coordinate }) {
            self.place = place
            locationNameLabel.text = place.name
            addressLabel.text = place.address
            openingHoursLabel.text = place.openingHours
            
            if let url = URL(string: place.imageName.first ?? "") {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.calloutImageView.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getDistance(distance: String) {
        distanceLabel.text = distance
        self.distance = distance
    }
    
    // MARK: - IBActions
    @IBAction func buildRouteButtonAction(_ sender: Any) {
        buildRoute?()
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        guard let place = place else { return }
        showOverlay?(place, distance ?? "Нет данных о местоположении")
    }
}


