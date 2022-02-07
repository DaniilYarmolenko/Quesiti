//
//  ViewController.swift
//  MapDemo
//
//  Created by Даниил Ярмоленко on 07.11.2021.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftUI
import GoogleMapsUtils
import Firebase
import CoreLocation
struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}
var userOfQuestion = [UserPlusQuestionLocalModal(uid: "", userName: "", data: 0.0, questionTitle: "", questionText: "", userImage: UIImage(named: "avatar")!, radius: 200, time: Date(timeIntervalSince1970: 10), countAnswer: 0)]
class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    
    let circle = GMSCircle()
    var imgString: String = ""
    let kClusterItemCount = 10000
    //    var filter = false //filterViewCheck
    var presenter: MapViewPresenter!
    var zoom: Float = 15.0
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var clusterManager: GMUClusterManager!
    var chosenPlace: MyPlace?
    //    var circle = GMSCircle()
    //let us = User(dictionary: [:])
    var questions: [QuestionModel] = []
    let ref = Database.database().reference()
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        myMapView.delegate=self
        //        getAllQuestions()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(showPartyMarkers), name: Notification.Name("showPartyMarkers"), object: nil)
        
        questionPreviewView=QuestionPreviewView(frame: CGRect(x: 0, y: 0, width: 200, height: 65))
        setupTextField(textField: txtFieldSearch, img: UIImage(systemName: "mappin.circle") ?? #imageLiteral(resourceName: "map_Pin"))
        initGoogleMaps()
        
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [15], backgroundColors: [ThemeColors.mainColor])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: myMapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: myMapView, algorithm: algorithm,
                                           renderer: renderer)
        txtFieldSearch.delegate=self
        showPartyMarkers()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clusterManager.setMapDelegate(self)
        clusterManager.cluster()
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
        clusterManager.cluster()
    }
    
    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //        filterPreviewView.removeFromSuperview()
        
        if let customMarkerView = marker.iconView as? CustomMarkerView{
            mapView.animate(toZoom: 17)
            self.setupCircle(latitide:  marker.position.latitude , longitude: marker.position.longitude, radius: userOfQuestion[customMarkerView.tag].radius)
        }
        //        else{
        //            self.setupCircle(latitide:  marker.position.latitude ?? 0.0, longitude: marker.position.longitude ?? 0.0, radius: 0)
        //        }
        if marker.userData is GMUCluster {
            mapView.animate(toZoom: mapView.camera.zoom + 1)
            NSLog("Did tap cluster")
            return true
        }
        marker.tracksViewChanges = true
        //        let camera = GMSCameraPosition.
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        zoom = mapView.camera.zoom
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        questionPreviewView.setData(title: userOfQuestion[customMarkerView.tag].questionTitle, img: customMarkerView.imageConst!, name: userOfQuestion[customMarkerView.tag].userName, time: userOfQuestion[customMarkerView.tag].time, countAnswer: userOfQuestion[customMarkerView.tag].countAnswer)
        return questionPreviewView
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let key = customMarkerView.keyQuestion
        let radius = userOfQuestion[customMarkerView.tag].radius
        let markerLong = marker.position.longitude
        let markerLat = marker.position.latitude
        let myLong = locationManager.location?.coordinate.longitude  ?? 0.0// сравнить с координатами вопроса
        let myLat = locationManager.location?.coordinate.latitude  ?? 0.0// сравнить с координатами
        var permissionAsq: Bool = false
        let currenResult = measure(lat1: markerLat, lon1: markerLong, lat2: myLat, lon2: myLong)
        if(currenResult < radius.doubleValue){
            permissionAsq = true
        } else{
            permissionAsq = false
        }
//        [markerLong, markerLat, myLong, myLat].forEach{
//            print("\($0)")
//        }
//        print("CURRENT RESULT = \(currenResult), radius = \(radius), permission - \(permissionAsq)")
        if(key == nil) {
            return
        }
//        print("radius = \(radius) + permission = \(permissionAsq)")
        restaurantTapped(keyQuestion: key ?? "", keyID: customMarkerView.keyID, distance: currenResult, radius: radius, permissionAsq: permissionAsq, imageUser: customMarkerView.imageConst!, countAnswer: userOfQuestion[customMarkerView.tag].countAnswer, nameUser: userOfQuestion[customMarkerView.tag].userName, titleQuestion: userOfQuestion[customMarkerView.tag].questionTitle, textQuestion: userOfQuestion[customMarkerView.tag].questionText, time: userOfQuestion[customMarkerView.tag].time)
        
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.setupCircle(latitide: 0.0, longitude: 0.0, radius: 0)
    }
    func measure(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double{  // generally used geo measurement function
        let R = 6378.137; // Radius of earth in M
        let pi = 3.1415926
        let dLat = abs(lat2 * pi/180 - lat1 * pi/180)
        let latPlus = lat2 * pi/180 + lat1 * pi/180
        let dLon = abs(lon2 * pi/180 - lon1 * pi/180)
        let conv = sqrt(sin(dLat/2)*sin(dLat/2)+(1-sin(dLat/2)*sin(dLat/2)-sin(latPlus/2)*sin(latPlus/2))*sin(dLon/2)*sin(dLon/2))
        let rez = 2*R*asin(conv)*1000
        return rez // meters
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
    }
    
    @objc func showPartyMarkers() {
        myMapView.clear()
        var i = 0
        userOfQuestion = []
        clusterManager.clearItems()
        let marker = GMSMarker()
//        print("VIZVAL")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("questions").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let location = snapshot.value as? [String:Any] {
                    for eachLocation in location {
                        
                        self.ref.child("questions").child("\(eachLocation.key)").observeSingleEvent(of: .value) { (snapshot) in
                            if let locationquest = snapshot.value as? [String:Any] {
                                for eachqueastion in locationquest {
                                    
                                    if let questionValue = eachqueastion.value as? [String: Any] {
                                        
                                        if let lavLatitude = questionValue["latitude"] as? Double {
                                            
                                            if let lavLongitude = questionValue["longitude"] as? Double {
                                                if let radius = questionValue["radius"] as? Int {
                                                    let marker = GMSMarker()
                                                    let questionTitle = questionValue["titleQuestion"] as? String
                                                    let questionText = questionValue["textQuestion"] as? String
                                                    let timeDate = questionValue["creationDate"] as? Double
                                                    let countOfAnswer = questionValue["answerCount"] as? Int
                                                    let time = Date(timeIntervalSince1970: timeDate ?? 50)
                                                    self.ref.child("users").child("\(eachLocation.key)").observeSingleEvent(of: .value){ (snapshot) in
                                                        
                                                        if let getData = snapshot.value as? [String:Any] {
                                                            if let imageSTR = getData["avatarURL"] as? String{
                                                                let username = getData["name"] as? String
                                                                
                                                                self.imgString = imageSTR
                                                                let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: 50, height: 70), image: imageSTR, borderColor: UIColor.darkGray, keyQuestion: eachqueastion.key, keyID: eachLocation.key, radius: radius, tag: i )
                                                                
                                                                marker.iconView = customMarker
                                                                marker.position = CLLocationCoordinate2D(latitude: lavLatitude, longitude: lavLongitude)
                                                                marker.map = self.myMapView
                                                                let dictionary = UserPlusQuestionLocalModal(uid: uid, userName: username!, data: 0.0, questionTitle: questionTitle!, questionText: questionText!, userImage: customMarker.imageConst!, radius: radius, time: time, countAnswer: countOfAnswer!)
                                                                userOfQuestion.append(dictionary)
                                                                i+=1
                                                                self.clusterManager.add(marker)
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
    
    func setupViews() {
        
        [myMapView, txtFieldSearch, btnMyLocation, btnAddQuestion, btnReload].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            myMapView.topAnchor.constraint(equalTo: view.topAnchor),
            myMapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            myMapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            myMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            txtFieldSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            txtFieldSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            txtFieldSearch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            txtFieldSearch.heightAnchor.constraint(equalToConstant: 35),
            
            btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            btnMyLocation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            btnMyLocation.widthAnchor.constraint(equalToConstant: 40),
            btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor),
            
            btnReload.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            btnReload.widthAnchor.constraint(equalToConstant: 40),
            btnReload.heightAnchor.constraint(equalTo: btnReload.widthAnchor),
            btnReload.topAnchor.constraint(equalTo: txtFieldSearch.bottomAnchor, constant: 50),
            
            btnAddQuestion.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65),
            btnAddQuestion.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAddQuestion.widthAnchor.constraint(equalToConstant: 50),
            btnAddQuestion.heightAnchor.constraint(equalTo: btnAddQuestion.widthAnchor)
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
    
    var questionPreviewView: QuestionPreviewView = {
        let rest = QuestionPreviewView()
        return rest
    }()
    //    var filterPreviewView: FilterPreviewView = {
    //        let rest = FilterPreviewView()
    //        rest.translatesAutoresizingMaskIntoConstraints = false
    //        return rest
    //    }()
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn.layer.masksToBounds = false
        btn.layer.shadowRadius = 2.0
        btn.layer.shadowOpacity = 0.2
        
        let config = UIImage.SymbolConfiguration(textStyle: .title2)
        btn.setImage(UIImage(systemName: "location.fill", withConfiguration: config), for: .normal)
        btn.layer.cornerRadius = 20
        //        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor = ThemeColors.mainColor
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    //    let btnFilter: UIButton = {
    //        let btn=UIButton()
    //        btn.backgroundColor = UIColor.white
    //        btn.layer.cornerRadius = 20
    //        let config = UIImage.SymbolConfiguration(textStyle: .title2)
    //        btn.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle", withConfiguration: config), for: .normal)
    //        btn.layer.shadowColor = UIColor.black.cgColor
    //        btn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    //        btn.layer.masksToBounds = false
    //        btn.layer.shadowRadius = 2.0
    //        btn.layer.shadowOpacity = 0.5
    //        //        btn.tintColor = UIColor.gray
    //        btn.imageView?.tintColor = ThemeColors.mainColor
    //        btn.addTarget(self, action: #selector(btnFilterAction), for: .touchUpInside)
    //        btn.translatesAutoresizingMaskIntoConstraints=false
    //        return btn
    //    }()
    let btnReload: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 20
        let config = UIImage.SymbolConfiguration(textStyle: .title2)
        btn.setImage(UIImage(systemName: "goforward", withConfiguration: config), for: .normal)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn.layer.masksToBounds = false
        btn.layer.shadowRadius = 2.0
        btn.layer.shadowOpacity = 0.2
        //        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor = ThemeColors.mainColor
        btn.addTarget(self, action: #selector(btnReloadAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let btnAddQuestion: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = ThemeColors.mainColor
        btn.applyGradient(colors: [UIColor(red: 48/255, green: 177/255, blue: 206/255, alpha: 1).cgColor, UIColor(red: 49/255, green: 141/255, blue: 178/255, alpha: 1).cgColor])
        
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        btn.setImage(UIImage(systemName: "plus.circle", withConfiguration: config), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.white
        btn.imageView?.sizeToFit()
        btn.addTarget(self, action: #selector(btnAddQuestionAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    
    @objc func restaurantTapped(keyQuestion: String, keyID: String, distance: Double, radius: Int, permissionAsq: Bool, imageUser: UIImage, countAnswer: Int, nameUser: String, titleQuestion: String, textQuestion: String, time: Date) {
        let rest = DetailsVC()
        rest.keyID = keyID
        rest.keyQuestion = keyQuestion
        rest.distance = distance
        rest.radius = radius
        rest.permissionAsq = permissionAsq
        rest.imgView.setImage(imageUser, for: .normal)
        rest.countAnswer = countAnswer
        rest.nameUser = nameUser
        rest.time = time
        
        rest.titleQuestion = titleQuestion
        rest.textQuestion = textQuestion
        //rest.passedData = question[tag]
        
        self.navigationController?.pushViewController(rest, animated: true)
    }
    
    @objc func btnMyLocationAction() {
        let location: CLLocation? = myMapView.myLocation
        if location != nil {
            myMapView.animate(toLocation: (location?.coordinate)!)
            myMapView.animate(toZoom: 17)
        }
    }
    @objc func btnReloadAction() {
        NotificationCenter.default.post(name: Notification.Name("showPartyMarkers"), object: nil)
    }
    
    //
    //    @objc func btnFilterAction() {
    //        if(filter == true){
    //            filterPreviewView.isHidden = true
    //            filter = false
    //        } else{
    //
    //            filterPreviewView.isHidden = false
    //            filter = true
    //        }
    //    }
    @objc func btnZoomPlusAction() {
        let zoomPlus = zoom+1
        myMapView.animate(toZoom: zoomPlus)
    }
    @objc func btnAddQuestionAction() {
        let addQuuestion: AddQuestionViewController = AddQuestionViewController()
        addQuuestion.modalPresentationStyle = .fullScreen
        self.present(addQuuestion, animated: true, completion: nil)
    }
    @objc func btnZoomMinusAction() {
        let zoomMinus = zoom-1
        myMapView.animate(toZoom: zoomMinus)
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
    
    
}

extension UIViewController {
    func transitionVc(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
        let customVcTransition = vc
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(customVcTransition, animated: false, completion: nil)
    }
    func transitionOutVc(duration: CFTimeInterval, type: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }
}

extension Int {
    var doubleValue: Double {
        return Double(self)
    }
}
