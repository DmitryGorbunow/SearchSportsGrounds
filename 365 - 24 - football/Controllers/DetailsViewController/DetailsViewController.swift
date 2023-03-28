//
//  DetailsViewController.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/19/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var openingHoursLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var bookingButton: UIButton!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var detailsImageCollectionView: UICollectionView!
    
    var place: Place
    var distance: String
    
    init(place: Place, distance: String) {
        self.place = place
        self.distance = distance
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configure()
        detailsImageCollectionView.register(UINib(nibName: "DetailsImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailsImageCollectionViewCell")
 
        
        let websiteLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.websiteLabelTapped(_:)))
        self.websiteLabel.isUserInteractionEnabled = true
        self.websiteLabel.addGestureRecognizer(websiteLabelTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupViews() {
        self.navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black

        bookingButton.corneredRadius(radius: 25)
        bookingButton.setShadow()
    }
    
    func configure() {
        locationNameLabel.text = place.name
        locationAddressLabel.text = place.address
        
        locationDescriptionLabel.text = place.locationDescription
        distanceLabel.text = distance
        openingHoursLabel.text = place.openingHours
        phoneNumberLabel.text = place.phoneNumber.isEmpty ? "Телефонный номер не указан" : place.phoneNumber
        
        if place.website.isEmpty {
            websiteLabel.text = "Сайт не указан"
            websiteLabel.textColor = .black
        } else {
            websiteLabel.text = place.website
        }
    }
    
    @objc func websiteLabelTapped(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: place.website) {
            UIApplication.shared.open(url)
        }
    }

    @IBAction func bookingButtonAction(_ sender: Any) {
        let sb = UIStoryboard(name: "BookingViewController", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "Booking")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return place.imageName.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = detailsImageCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailsImageCollectionViewCell", for: indexPath) as? DetailsImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureImage(URLString: place.imageName[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 165)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


