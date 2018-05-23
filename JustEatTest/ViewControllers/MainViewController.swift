//
//  MainViewController.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OutcodeInputViewControllerDelegate {

    private var requestManager: WebRequestManager?
    private var outcode: String = "se19"
    private var restaurants: [Restaurant] = []

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Restaurants"
        self.tableView.rowHeight = 76.0
        self.tableView.separatorColor = UIColor(red: 43.0/255.0, green: 131.0/255.0, blue: 159.0/255.0, alpha: 1)
        self.tableView.register(UINib(nibName: "RestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")

        let getRestaurantsButton = UIBarButtonItem(title: "Get restaurants", style: UIBarButtonItemStyle.plain, target: self, action: #selector(getRestaurants(sender:)))
        self.navigationItem.leftBarButtonItem = getRestaurantsButton
        let outcodeButton = UIBarButtonItem(title: "Outcode", style: UIBarButtonItemStyle.plain, target: self, action: #selector(presentOutcodeInputView(sender:)))
        self.navigationItem.rightBarButtonItem = outcodeButton

        // Use single connection per host for current configuration
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 1

        // Instantiate WebRequestManager
        requestManager = WebRequestManager(config: configuration, acceptableStatusCodes: 200..<300)
    }

    // MARK: - User actions
    @objc private func getRestaurants(sender: UIBarButtonItem) {
        self.getRestaurantsList()
    }

    @objc private func presentOutcodeInputView(sender: UIBarButtonItem) {
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
        return self.restaurants.count == 0 ? 1 : self.restaurants.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RestaurantTableViewCell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantTableViewCell

        if (indexPath.row == 0 && self.restaurants.count == 0) {
            cell.restaurant = nil
        } else {
            cell.restaurant = restaurants[indexPath.row]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Private methods
    private func getRestaurantsList()
    {
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
                            return parsed
        }

        let task = requestManager?.request(URL(string:DefaultTestParameters.defaultAPIServer)!, resource: restaurantsResource) { [weak self] result -> Void in
            switch result {
            case .resultSuccess(let resultData, _, _):
                DispatchQueue.main.async {
                    self?.restaurants = resultData!
                    self?.tableView.reloadData()
                }
                break
            case .resultError(let error, _):
                DispatchQueue.main.async {
                    print(error)
                }
                break
            }
        }
        task?.resume()
    }

    private func constructParams() -> [String: String] {
        return ["q": self.outcode]
    }
}
