//
//  MainViewController.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, OutcodeInputViewControllerDelegate {

    private var requestManager: WebRequestManager?
    private var outcode: String = "se19"
    private var restaurants: [Restaurant] = []
    private let locationManager = CLLocationManager()
    private var location: CLLocation?

    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    @IBOutlet var loadDataButton: UIButton!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(self.refreshRestaurants(sender:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.BlueGrey()
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Ask for authorization on CoreLocation services from the user
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        // Setup activity view and hide it
        self.view.bringSubviewToFront(self.activityView)
        self.activityView.color = UIColor.BlueGrey()
        self.activityView.hidesWhenStopped = true
        self.activityView.stopAnimating()

        self.loadDataButton.addTarget(self, action:#selector(self.refreshRestaurants(sender:)), for: .touchUpInside)

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            // For restaurants search, we don't need more precise
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }

        self.title = "Restaurants"

        self.tableView.rowHeight = 76.0
        self.tableView.separatorColor = UIColor(red: 43.0/255.0, green: 131.0/255.0, blue: 159.0/255.0, alpha: 1)
        self.tableView.register(UINib(nibName: "RestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
        self.tableView.addSubview(self.refreshControl)

        let getRestaurantsButton = UIBarButtonItem(title: "Near you", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.getNearestRestaurants(sender:)))
        self.navigationItem.leftBarButtonItem = getRestaurantsButton
        let outcodeButton = UIBarButtonItem(title: "Outcode", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.presentOutcodeInputView(sender:)))
        self.navigationItem.rightBarButtonItem = outcodeButton

        // Use single connection per host for current configuration
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 1
        // Save an instance of WebRequestManager
        self.requestManager = WebRequestManager(config: configuration, acceptableStatusCodes: 200..<300)
    }

    // MARK: - User actions
    @objc func getNearestRestaurants(sender: UIBarButtonItem) {
        self.getRestaurantsList(location: self.location)
    }

    @objc func refreshRestaurants(sender: UIButton!) {
        self.getRestaurantsList()
    }

    @objc func presentOutcodeInputView(sender: UIBarButtonItem) {
        let outcodeInputViewController = OutcodeInputViewController(nibName: "OutcodeInputViewController", bundle: nil)
        outcodeInputViewController.delegate = self
        outcodeInputViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        outcodeInputViewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        let modalNavigationController = UINavigationController(rootViewController: outcodeInputViewController)
        self.present(modalNavigationController, animated: true, completion: {
            outcodeInputViewController.textFieldOutcode?.text = self.outcode
        })
    }

    // MARK: - Outcode ViewController delegate
    func didDismissOutcodeInputView(outcode: String) {
        self.outcode = outcode
    }

    // MARK: - Table View related methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RestaurantTableViewCell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantTableViewCell

        cell.logoImageView?.image = nil
        cell.logoImageView?.image = UIImage(named: "empty")
        cell.restaurant = restaurants[indexPath.row]

        if (indexPath.row % 2 != 0) {
            cell.backgroundColor = UIColor.AmbientGray();
        } else {
            cell.backgroundColor = UIColor.white;
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Location services methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else {
            return
        }
        self.location = manager.location
        print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
    }

    // MARK: - Private methods

    private func getRestaurantsList(location: CLLocation? = nil) {
        self.activityView.startAnimating()
        self.restaurants = []
        self.tableView.reloadData()

        // Configure WEB-resource
        let restaurantsResource =
            WebResource(path: DefaultTestParameters.defaultRestaurantsEndpoint,
                        method: HTTPMethod.GET,
                        params: self.constructParams(),
                        headers: DefaultTestParameters.defaultHeaders) { data -> [Restaurant]? in
                            guard
                                let data = data,
                                let json = try? JSONSerialization.jsonObject(with: data) as! [String: Any],
                                let restaurants = json["Restaurants"] as? [[String: Any]]
                                else {
                                    return nil
                            }
                            let parsed: [Restaurant] = restaurants.compactMap({ item -> Restaurant in
                                return Restaurant(item)
                            })
                            guard let userLocation = location else {
                                return parsed
                            }
                            let filtered = parsed.filter({ restaurant -> Bool in
                                guard let restaurantLocation = restaurant.location else {
                                    return false
                                }
                                let distance = userLocation.distance(from:restaurantLocation)
                                return distance < 1000
                            })
                            return filtered
        }

        let task = requestManager?.request(URL(string:DefaultTestParameters.defaultAPIServer)!, resource: restaurantsResource) { [weak self] result -> Void in
            DispatchQueue.main.async {
                self?.activityView.stopAnimating()
                self?.refreshControl.endRefreshing()
                switch result {
                case .resultSuccess(let resultData, _, _):
                    self?.restaurants = resultData!
                    self?.tableView.reloadData()
                    if let count = self?.restaurants.count, count > 0 {
                        self?.loadDataButton.isHidden = true
                    } else {
                        self?.loadDataButton.isHidden = false
                    }
                    break
                case .resultError(let error, _):
                    let alertController = UIAlertController(title: "Warning", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    self?.present(alertController, animated: true, completion: nil)
                    print(error.localizedDescription)
                    self?.loadDataButton.isHidden = false
                    self?.tableView.reloadData()
                    break
                }
            }
        }
        task?.resume()
    }

    private func constructParams() -> [String: String] {
        return ["q": self.outcode]
    }
}
