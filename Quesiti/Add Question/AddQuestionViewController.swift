//
//  AddQuestionViewController.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 29.10.2021.
//

import UIKit
import GoogleMaps
import GooglePlaces


class AddQuestionViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate  {
    
    
    var presenter: AddQuestionViewPresenter!
    var zoom: Float = 15.0
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    let circle = GMSCircle()
    var radius: Int = 200
    var adressLabel = ""
    var longtitudeQuestion: Double = 0.0
    var latitudeQuestion: Double = 0.0
    //    var circle = GMSCircle()
//    var question = [
//        QuestionModel(title: "Какая погода", userID: "bjhksdf23", latitude: 24.8655, longitude: 67.0011, radius: 1000, image: UIImage(named: "people1"), name: "Daniil Yarmolenko"),
//        QuestionModel(title: "Какая погода", userID: "bjhksdf23", latitude: 24.868, longitude: 67.0011, radius: 1000, image: UIImage(named: "people2"), name: "Daniil Yarmolenko"),
//        QuestionModel(title: "Какая погода", userID: "bjhksdf23", latitude: 24.878, longitude: 67.0011, radius: 1000, image: UIImage(named: "people3"), name: "Daniil Yarmolenko")
//    ]
    
    var question: [String] = []
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        myMapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        setupViews()
        
        addQuestionPreviewView = AddQuestionPreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 100, height: 70))
        setupTextField(textField: txtFieldSearch, img: UIImage(systemName: "mappin.circle") ?? #imageLiteral(resourceName: "map_Pin"))
        
        initGoogleMaps()
        
        txtFieldSearch.delegate = self
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    } // delegdt textfield
    
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        
        //        showPartyMarkers(lat: longitude, long: longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.0)
        myMapView.camera = camera
        txtFieldSearch.text=place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: latitude, long: longitude)
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "\(place.name ?? "")"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = myMapView
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.location?.coordinate.latitude ?? 27.0, longitude: locationManager.location?.coordinate.longitude ?? 27.0, zoom: 17.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
        let long = locationManager.location?.coordinate.longitude
        let lat = locationManager.location?.coordinate.latitude
        latitudeQuestion = lat ?? 0.0
        longtitudeQuestion = long ?? 0.0
        if (lat != nil && long != nil) {
            
            self.setupCircle(latitide: lat ?? 0.0, longitude: long ?? 0.0, radius: radius)
        }
        let position = CLLocationCoordinate2D(latitude: lat ?? 0.0, longitude: long ?? 0.0)
        let marker = GMSMarker(position: position)
        marker.title = "Hello World"
        marker.map = myMapView
        reverseGeocode(coordinate: position)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: zoom)
        
        self.myMapView.animate(to: camera)
        //        showPartyMarkers(lat: lat, long: long)
    }
  
    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        self.latitudeQuestion = latitude
        self.longtitudeQuestion = longitude
        reverseGeocode(coordinate: coordinate)
        marker.title = "Hello World"
        marker.map = mapView
        self.setupCircle(latitide: latitude, longitude: longitude, radius: radius)
        
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocode(coordinate: position.target)
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        btnNextAction()
    }
    
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        addQuestionPreviewView.setData(radius: "\(radius)", adress: adressLabel)
        return addQuestionPreviewView
    }
    
    
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        imageView.tintColor = ThemeColors.mainColor
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
    func setupCircle(latitide: CLLocationDegrees, longitude: CLLocationDegrees, radius: Int){
        let circleCenter = CLLocationCoordinate2DMake(CLLocationDegrees(latitide), CLLocationDegrees(longitude))
        circle.position = circleCenter
        circle.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha:  0.05)
        circle.strokeColor = UIColor.red
        circle.strokeWidth = 1
        circle.map = myMapView
        
        circle.radius = CLLocationDistance(radius)
    }
    
    func setupViews() {
        
        [myMapView, txtFieldSearch, slider, containerRadiusLabel, btnMyLocation, btnMyLocation, btncClose, btnNext].forEach {
            view.addSubview($0)
        }
        containerRadiusLabel.addSubview(textRadius)
        
        NSLayoutConstraint.activate([
            myMapView.topAnchor.constraint(equalTo: view.topAnchor),
            myMapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            myMapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            myMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            txtFieldSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            txtFieldSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            txtFieldSearch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            txtFieldSearch.heightAnchor.constraint(equalToConstant: 35),
            
            containerRadiusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            containerRadiusLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            containerRadiusLabel.heightAnchor.constraint(equalToConstant: 20),
            containerRadiusLabel.widthAnchor.constraint(equalToConstant: 200),
            
            textRadius.centerYAnchor.constraint(equalTo: containerRadiusLabel.centerYAnchor),
            textRadius.centerXAnchor.constraint(equalTo: containerRadiusLabel.centerXAnchor),
            
            
            btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            btnMyLocation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            btnMyLocation.widthAnchor.constraint(equalToConstant: 40),
            btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor),
            
            btncClose.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            btncClose.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            btncClose.widthAnchor.constraint(equalToConstant: 50),
            btncClose.heightAnchor.constraint(equalTo: btncClose.widthAnchor),
            
            btnNext.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            btnNext.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            btnNext.widthAnchor.constraint(equalToConstant: 50),
            btnNext.heightAnchor.constraint(equalTo: btnNext.widthAnchor)
        ])
        
    }
    
    
    
    let myMapView: GMSMapView = {
        let map = GMSMapView()
        map.translatesAutoresizingMaskIntoConstraints=false
        return map
    }()
    
    let txtFieldSearch: UITextField = {
        let tf=UITextField()
        tf.layer.cornerRadius = 15
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder="Search for a location"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var addQuestionPreviewView: AddQuestionPreviewView = {
        let rest = AddQuestionPreviewView()
        return rest
    }()
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn.layer.masksToBounds = false
        btn.layer.shadowRadius = 2.0
        btn.layer.shadowOpacity = 0.5
        
        let config = UIImage.SymbolConfiguration(textStyle: .title2)
        btn.setImage(UIImage(systemName: "location.fill", withConfiguration: config), for: .normal)
        btn.layer.cornerRadius = 20
        //        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor = ThemeColors.mainColor
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let btncClose: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.clear
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        
        
        btn.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        btn.imageView?.tintColor = ThemeColors.mainColor
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        //        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor = ThemeColors.secondaryColor
        btn.addTarget(self, action: #selector(btnClose(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let btnNext: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.clear
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        btn.setImage(UIImage(systemName: "chevron.right", withConfiguration: config), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        //        btn.tintColor = UIColor.gray
        
        btn.imageView?.tintColor = ThemeColors.secondaryColor
        btn.addTarget(self, action: #selector(btnNextAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let containerRadiusLabel: UIView = {
        let v = UIView()
        v.backgroundColor = ThemeColors.secondaryColor
        v.layer.cornerRadius = 10
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let textRadius: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints=false
        title.text = "Радиус зоны действия 200 м"
        title.font = UIFont.systemFont(ofSize: 10)
        title.textAlignment = .center
        return title
    }()
    var slider: UISlider {
        let slider = UISlider(frame:CGRect(x: 20, y: view.frame.width*2 - 60, width: view.frame.width-40, height: 20))
        slider.minimumValue = 200
        slider.maximumValue = 2000
        slider.isContinuous = true
        slider.tintColor = UIColor.black
        slider.addTarget(self, action: #selector(AddQuestionViewController.sliderValueChanged(_:)), for: .valueChanged)
        //        slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
        //        slider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -20),
        //        slider.translatesAutoresizingMaskIntoConstraints=false
        //        slider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        return slider
    }
    
    @objc func restaurantTapped(tag: Int) {
        let rest = DetailsVC()
        //rest.passedData = question[tag]
        self.navigationController?.pushViewController(rest, animated: true)
    }
    
    @objc func btnMyLocationAction() {
        let location: CLLocation? = myMapView.myLocation
        
        
        myMapView.clear()
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        
        if location != nil {
            myMapView.animate(toLocation: (location?.coordinate)!)
            self.setupCircle(latitide: latitude ?? 0.0, longitude: longitude ?? 0.0, radius: radius)
        }
        let position = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        let marker = GMSMarker(position: position)
        marker.title = "Hello World"
        marker.map = myMapView
    }
    
    @objc func btnZoomPlusAction() {
        let zoomPlus = zoom+1
        myMapView.animate(toZoom: zoomPlus)
    }
    @objc func btnZoomMinusAction() {
        let zoomMinus = zoom-1
        myMapView.animate(toZoom: zoomMinus)
    }
    @objc func sliderValueChanged(_ sender: UISlider!){
        let currentValue = Int(sender.value)
        updateCircle(value: currentValue)
    }
    @objc func btnClose(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func btnNextAction(){
        let next: addQuestionTwoVC = addQuestionTwoVC()
        let coordinate  =  CLLocationCoordinate2D(latitude: self.longtitudeQuestion, longitude: self.latitudeQuestion)
        reverseGeocode(coordinate: coordinate)
        next.questionAdress = adressLabel
        next.questionRadius = radius
        next.questionLongitude = longtitudeQuestion
        next.questionLatitude = latitudeQuestion
        next.modalPresentationStyle = .fullScreen
        transitionVc(vc: next, duration: 0.5, type: .fromRight)
    }
    
    private func updateCircle(value: Int){
        DispatchQueue.main.async {
            self.circle.radius = CLLocationDistance(value)
            let update = GMSCameraUpdate.fit(self.circle.bounds())
            self.textRadius.text = "Радиус зоны действия \(value) м"
            self.myMapView.animate(with: update)
            self.radius = value
        }
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let lines = address.lines
            else {
                return
            }
            self.adressLabel = lines.joined(separator: "\n")
        }
    }
}

