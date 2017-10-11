//
// The MIT License (MIT)
//
// Copyright (c) 2015 Sonos, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

class MasterViewController: UITableViewController, GroupDiscoveryListener {
    typealias ObjectType = [String: String]

    // MARK: Properties
    @IBOutlet weak var instructionBlock: UILabel!
    @IBOutlet var gradientView: UITableView!
    @IBOutlet weak var prompt: UIView!
    @IBOutlet weak var groupButton: UIButton!

    var detailViewController: DetailViewController?
    var objects = [ObjectType]()
    var discovery: GroupDiscoveryProtocol?
    var timeout: Timer?

    var selected: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register callbacks so that DetailViewController can send updates to MasterViewController.
        // This is only used to highlight group selected on iPads, which use split views.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.onSelectionInvalidated = self.onSelectionInvalidated
            appDelegate.onNewSelection = self.onNewSelection
        }

        let scale = UIScreen.main.scale

        groupButton.layer.borderWidth = 1/scale
        groupButton.layer.borderColor = UIColor.white.cgColor

        NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.handleStartDiscovery(_:)),
            name: NSNotification.Name(rawValue: "StartDiscovery"), object: nil)

        // Set the navigation bar background to Black and font color to white
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 19.0)]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.startDiscovery()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.discovery!.stop()
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
            cell.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     * Callback method, from `GroupDiscoveryListener` protocol, called when a new group discovery event occurs. The event handler
     * is passed as a current hash of groups and their corresponding information
     *
     * - parameter groups: Map of group Ids to group information objects
     */
    func onGroupDiscoveryUpdate(_ groups: [String: ObjectType]) {
        var tempObjects = [ObjectType]()
        // Find all the group coordinators and add them to objects
        for (_, group) in groups {
            if group[SonosGroupDiscovery.GROUP_COORDINATOR_KEY] == "1" {
                tempObjects.append(group)
            }
        }

        // If we found speakers, then stop the timeout timer and change the label
        if !tempObjects.isEmpty {
            tempObjects.sort(by: { (obj1: ObjectType!, obj2: ObjectType!) -> Bool in
                return obj1[SonosGroupDiscovery.GROUP_ID_KEY]! < obj2[SonosGroupDiscovery.GROUP_ID_KEY]!
            })

            self.timeout?.invalidate()
            self.timeout = nil

            self.instructionBlock.text = "Welcome to the Sonos sample application. Enjoy playing around with our APIs. " +
                "If you want to edit Sonos speaker groups go to the Sonos app."
        }

        updateObjects(tempObjects)
    }

    @objc fileprivate func handleStartDiscovery(_ notification: Notification) {
        if notification.name.rawValue == "StartDiscovery" {
            startDiscovery()
        }
    }

    func startDiscovery() {
        // Disable group discovery for functional test since the test injects its own group discovery instance
        if let disableDiscovery = value(forKey: "disableDiscoveryForTest") as? Bool, disableDiscovery == true {
            self.timeout = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(MasterViewController.handleTimeout),
                                                                  userInfo: nil, repeats: false)
        } else {
            objects.removeAll(keepingCapacity: true)
            self.tableView.reloadData()

            // Set up Group Discovery to find Sonos devices
            self.discovery = SonosGroupDiscovery()
            self.discovery!.listen(self)
            self.discovery!.start()

            self.timeout = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(MasterViewController.handleTimeout),
                 userInfo: nil, repeats: false)
        }
    }

    override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }

    func handleTimeout() {
        self.instructionBlock.text = "No Sonos Speakers found on your network"
        updateObjects([["gname":"Try Again"]])

        self.discovery?.stop()
    }

    func updateObjects(_ objects: [ObjectType]) {
        var indexPaths = [IndexPath]()
        let oldCount = self.objects.count

        self.objects = objects

        if objects.count > oldCount {
            for i in 0...(objects.count - oldCount - 1) {
                indexPaths.append(IndexPath(row: i + oldCount, section: 0))
            }
            self.tableView.insertRows(at: indexPaths, with: .none)
        } else if objects.count != oldCount {
            for i in 0...(oldCount - objects.count - 1) {
                indexPaths.append(IndexPath(row: i + objects.count, section: 0))
            }
            self.tableView.deleteRows(at: indexPaths, with: .none)
        }

        self.tableView.reloadData()
    }

    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let object = objects[indexPath.row]
            if object[SonosGroupDiscovery.GROUP_NAME_KEY] == "Try Again" {
                self.startDiscovery()

                return false
            }
        }

        return true
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Groups", style:.plain, target:nil, action:nil)
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                if object.index(forKey: SonosGroupDiscovery.GROUP_ID_KEY) != nil {
                    NSLog("Group Name: %@, GroupId: %@, Websocket: %@, BootId/Config Id: %@",
                        object[SonosGroupDiscovery.GROUP_NAME_KEY]!, object[SonosGroupDiscovery.GROUP_ID_KEY]!,
                        object[SonosGroupDiscovery.WEBSOCKET_KEY]!, object[SonosGroupDiscovery.CONFIG_ID_KEY]!)
                }
                let controller = (segue.destination as! UINavigationController).topViewController
                    as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if cell.textLabel?.text != appDelegate.selected {
                cell.unhighlight()
            }
        }

        cell.selectionStyle = .none

        let object = objects[indexPath.row]


        let label = cell.textLabel!
        label.text = object[SonosGroupDiscovery.GROUP_NAME_KEY]?.capitalized

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let selected = appDelegate.selected, object[SonosGroupDiscovery.PLAYER_UUID_KEY] == selected {
                cell.highlight()
            }
        }

        let scale = UIScreen.main.scale

        cell.layer.borderWidth = 1/scale
        cell.layer.borderColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3).cgColor

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    // This method removes highlighting from the previously selected group in the UITableView
    func onSelectionInvalidated(_ previousSelection: String?) {
        let objectsCopy = objects
        if let vPreviousSelection = previousSelection {
            for i in 0...(objectsCopy.count - 1) {
                var object = objects[i]
                if object[SonosGroupDiscovery.PLAYER_UUID_KEY] == vPreviousSelection {
                    if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) {
                        cell.unhighlight()
                    }
                }
            }
        }
    }

    // This method highlights the newly selected group in the UITableView
    func onNewSelection(_ newSelection: String?) {
        let objectsCopy = objects
        if let vNewSelection = newSelection {
            for i in 0...(objectsCopy.count - 1) {
                var object = objects[i]
                if object[SonosGroupDiscovery.PLAYER_UUID_KEY] == vNewSelection {
                    if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) {
                        cell.highlight()
                    }
                }
            }
        }
    }

    // MARK: Actions

    @IBAction func groupButtonPressed(_ sender: AnyObject) {
        if let url = URL.init(string: "sonos://x-callback-url/navigate/roomsmenu") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(URL(string: "sonos://x-callback-url/navigate/roomsmenu")!)
            } else {
                UIApplication.shared.openURL(
                    URL(string: "https://itunes.apple.com/us/app/sonos-controller/id293523031")!)
            }
        }

    }

    @IBAction func unwindToMaster(_ segue: UIStoryboardSegue) {
    }
}

extension UITableViewCell {
    func highlight() {
        self.contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        self.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
    }

    func unhighlight() {
        self.contentView.backgroundColor = UIColor.clear
        self.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
    }
}
