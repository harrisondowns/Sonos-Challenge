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
import SonosUtils
import ControlApi
import MBProgressHUD

class DetailViewController: UIViewController, UIPopoverPresentationControllerDelegate, PlaybackListener, GroupListener, SonosGlobalListener, VolumeListener {
var sonosVolume: VolumeProtocol?
    // MARK: Properties
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var blackGradientView: GradientView!
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    var timer : Timer!
    var curVol = 0;
    var speakerStatus = 0;
    var player: PlaybackProtocol?
    var defaultAlbumArt = UIImage(named: "music_note.png")
    // The signature gradient contains a diagonal gradient with blue, purple, and red.
    var signatureGradient: UIImage?
    weak var volumePopOver: VolumePopOverViewController?
    fileprivate var task: URLSessionDataTask?
    var detailItem: [String: String]? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: [String:String] = self.detailItem {
            setPlayerSelection(detail[SonosGroupDiscovery.PLAYER_UUID_KEY])

            if let label = self.detailDescriptionLabel {
                label.text = detail[SonosGroupDiscovery.GROUP_NAME_KEY]
            }

            self.navigationItem.title = detail[SonosGroupDiscovery.GROUP_NAME_KEY]?.capitalized
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(lowerVol)), userInfo: nil, repeats: true)
        if let addr = self.detailItem?[SonosGroupDiscovery.WEBSOCKET_KEY] {
            if let groupId = self.detailItem![SonosGroupDiscovery.GROUP_ID_KEY] {
                if let householdId = self.detailItem![SonosGroupDiscovery.HOUSEHOLD_KEY] {
                    if let groupName = self.detailItem![SonosGroupDiscovery.GROUP_NAME_KEY] {
                        player = SonosPlayer(address: addr, groupId: groupId, householdId:
                            householdId, groupName: groupName)
                        player?.playbackListener = self
                        if var player = player as? SonosGlobalProtocol {
                            player.sonosGlobalListener = self
                        }
                        if var player = player as? GroupProtocol {
                            player.groupListener = self
                        }
                    }
                }
            }
        }

        // Set the navigation bar background to Black and font color to white
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 19.0)]

        blackGradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blackGradientView.generateGradient(UIColor.clear, UIColor.black)

        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Generate signature gradient
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds

        let firstColor = UIColor(red: 0.00, green: 0.75, blue: 1, alpha: 1)
        let midColor   = UIColor(red: 0.19, green: 0.19, blue: 0.51, alpha: 1)
        let lastColor  = UIColor(red: 0.93, green: 0.11, blue: 0.14, alpha: 1)
        gradient.colors = [firstColor.cgColor, midColor.cgColor, lastColor.cgColor]

        gradient.startPoint = CGPoint(x: 0.50, y: 1.0)
        gradient.endPoint   = CGPoint(x: 1.0, y: 0.0)

        UIGraphicsBeginImageContext(self.view.frame.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        self.signatureGradient = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.backgroundImageView.image = signatureGradient
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.disconnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onPlayStatusChanged(_ playing: Bool) {
        DispatchQueue.main.async {
            let imageName = playing ? "btn-pause.png": "btn-play.png"
            let image = UIImage(named: imageName)
            self.playButton.setImage(image!, for: UIControlState())
        }
    }

    func onPlaybackError(_ errorCode: String?, reason: String?) {
        showToast("Sonos Playback Error", details: errorCode)
    }

    func onGlobalError(_ errorCode: String?, reason: String?) {
        showToast("Sonos Global Error", details: errorCode)
    }

    /**
     * Displays a small black rectangle centered in the view with a label and details for 2 seconds.
     * This is used to display Control Api error messages.
     */
    func showToast(_ label: String?, details: String?) {
        let hud = MBProgressHUD.showAdded(to: self.navigationController?.view, animated: true)
        hud?.mode = MBProgressHUDMode.text
        hud?.labelText = label
        hud?.detailsLabelText = details
        hud?.hide(true, afterDelay: 2)
    }

    func onMetadataChanged(_ title: String?, artist: String?, album: String?, imageUrl: String?) {
        if let validImageUrl = imageUrl, let checkedUrl = URL(string: validImageUrl) {
            albumArtImageView.contentMode = .scaleAspectFit
            downloadImage(title, artist: artist, album: album, url: checkedUrl, player: player)
        } else {
            self.backgroundImageView.image = self.signatureGradient
            self.albumArtImageView.image = self.defaultAlbumArt
            displayMetadata(title, artist: artist, album: album)
        }
    }

    func onGroupCoordinatorUpdated(_ groupName: String?) {
        if let vGroupName = groupName {
            DispatchQueue.main.async {
                self.navigationItem.title = vGroupName.capitalized
            }
        }
    }

    func onGroupCoordinatorMoved(_ playerId: String?) {
        setPlayerSelection(playerId)
    }

    // Callback to show an alert, notifying the user, of a connection error with the group coordinator.
    func onConnectionError(_ error: NSError?) {
        volumePopOver?.dismiss(animated: true, completion: {})
        player?.disconnect()

        let message = "Connection to Sonos failed"
        var errorDescription = ""

        if let vError = error {
            errorDescription = " due to an error: \(vError.localizedDescription)"
        }

        displayUIAltert("Connection Failed", message: message + errorDescription)
    }

    func onGroupCoordinatorGone(_ groupName: String?) {
        setPlayerSelection(nil)

        var groupNameString = "[GROUP NAME]"

        if let vGroupName = groupName {
            groupNameString = vGroupName.capitalized
        }

        displayUIAltert("Disconnected", message: "Lost Control Of '\(groupNameString)'")
    }

    // Displays an alert with a the passed in title, message, and an "OK" dismiss button
    func displayUIAltert(_ title: String?, message: String?) {
        volumePopOver?.dismiss(animated: true, completion: {})

        let uiAlert = UIAlertController(title: title, message: message,
                                                          preferredStyle: UIAlertControllerStyle.alert)

        uiAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.groupGoneHandler()
        }))

        self.task?.cancel()
        present(uiAlert, animated: true, completion: nil)
    }

    // Handler for when the current group coordinator is gone. If on an iPad it, cleans the view.
    // If on an iPhone, it goes back to the group selection screen.
    func groupGoneHandler() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.backgroundImageView.image = self.signatureGradient
            self.albumArtImageView.image = nil
            self.navigationItem.title = ""
            self.artistField.text = ""
            self.titleField.text = ""
            self.onPlayStatusChanged(false)

            setPlayerSelection(nil)

            // Open groups menu with animation if it's not already open.
            if self.splitViewController?.displayMode == UISplitViewControllerDisplayMode.primaryHidden {
                let animations: () -> Void = {
                    self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.primaryOverlay
                }
                let completion: (Bool) -> Void = { _ in
                    self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.automatic
                }
                UIView.animate(withDuration: 0.3, animations: animations, completion: completion)
            }
        } else {
            self.performSegue(withIdentifier: "showMaster", sender: self)
        }
    }
    func grabTime(){
        let d = Date().timeIntervalSince1970
        let url = URL(string: "https://sonos-challenge.herokuapp.com/sensor1.txt?" + String(d))
        var da = ""
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
          //  print(String(data: data, encoding: String.Encoding.utf8) as String!)
            // let json = try! JSONSerialization.jsonObject(with: data, options: [])
            //print(json)
            da = String(data: data, encoding: String.Encoding.utf8) as String!
         //   self.handleVol(da: da);
        }
        
        task.resume()
    }
    
    
    func handleVol(da : String){
        if (da == "1"){
            
            speakerStatus = 1;
         //   sonosVolume?.setVolume(10)
         //   curVol = 10
          //  timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(lowerVol)), userInfo: nil, repeats: true)
            
            
         //   print ("gogogo")
        }
        else{
            speakerStatus = 0;
            
        }
    }
    
    func lowerVol(){
        print ("FIRE")
        if speakerStatus == 0 && curVol > 0{
            curVol -= 4
            
            let sonosVolume = player as? VolumeProtocol
            sonosVolume?.setVolume(curVol)
        }
        else if speakerStatus == 1 && curVol < 20{
            curVol += 4
            let sonosVolume = player as? VolumeProtocol
            sonosVolume?.setVolume(curVol)
        }
        else{
            grabTime()
          //  timer.invalidate()
        }
    }
    
    @IBAction func readHello(){
        //  print(sock.read())
        //grabTime()
        if (speakerStatus == 0){
            speakerStatus = 1;
        }
        else{
            speakerStatus = 0;
        }
       // if (s == "OFF"){
            
       // }
    }

    func getDataFromUrl(_ title: String?, artist: String?, album: String?, url: URL, completion: @escaping ((_ title: String?,
        _ artist: String?, _ album: String?, _ albumArt: UIImage?, _ backgroundArt: UIImage?,
        _ response: URLResponse?, _ error: NSError? ) -> Void)) {
            self.task?.cancel()
            self.task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                var albumArt: UIImage?
                var backgroundArt: UIImage?

                if let vData = data, vData.count > 0 {
                    NSLog("Image Download complete")
                    albumArt = UIImage(data: vData)

                    if let imageToBlur = CIImage(data: vData) {
                        // Apply a blur filter to album art
                        let context = CIContext(options: nil)
                        if let blurFilter = CIFilter(name: "CIGaussianBlur") {
                            blurFilter.setValue(imageToBlur, forKey: kCIInputImageKey)
                            if let resultImage = blurFilter.value(forKey: kCIOutputImageKey) as? CIImage {
                                let cgImage = context.createCGImage(resultImage, from: resultImage.extent)

                                // Crop the blurred album art to get rid of any blank space that resulted from blurring
                                let cropped = CIImage(cgImage: cgImage!).cropping(
                                    to: CGRect(x: (cgImage?.width)!/3, y: (cgImage?.height)!/3,
                                        width: (cgImage?.width)!/3, height: (cgImage?.height)!/3))

                                // Set the background art to the blurred album art
                                backgroundArt = UIImage(ciImage: cropped)
                            }
                        }
                    }
                }

                completion(title, artist, album, albumArt,
                           backgroundArt, response, error as NSError?)
        }) 
        task?.resume()
    }

    func downloadImage(_ title: String?, artist: String?, album: String?, url: URL, player: PlaybackProtocol?) {
        NSLog("Downloading Image: %@", url.absoluteString)
        getDataFromUrl(title, artist: artist, album: album, url: url) { (title, artist, album, albumArt,
            backgroundArt, response, error)  in
            self.task = nil
            DispatchQueue.main.async { () -> Void in
                if player?.isConnected() == true {
                    self.displayMetadata(title, artist: artist, album: album)

                    if let vAlbumArt = albumArt {
                        self.albumArtImageView.image = vAlbumArt
                    } else {
                        self.albumArtImageView.image = self.defaultAlbumArt
                        if error != nil {
                            NSLog("There was an error downloading the album art: %@", (url.absoluteString))
                        }
                    }

                    if let vBackgroundArt = backgroundArt {
                        self.backgroundImageView.image = vBackgroundArt
                    } else {
                        self.backgroundImageView.image = self.signatureGradient
                    }
                }
            }
        }
    }

    func displayMetadata(_ title: String?, artist: String?, album: String?) {
        var albumAndArtist = ""

        if let trimmedAlbum = album?.trimToWidth(self.artistField.frame, percentFill: 0.4) {
            albumAndArtist += trimmedAlbum
        }

        if let trimmedArtist = artist?.trimToWidth(self.artistField.frame, percentFill: 0.4) {
            if !albumAndArtist.isEmpty {
                albumAndArtist += " - "
            }

            albumAndArtist += trimmedArtist
        }

        self.artistField.text = albumAndArtist

        self.titleField.text = title?.trimToWidth(self.titleField.frame, percentFill: 0.9)

    }

    func setPlayerSelection(_ playerId: String?) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            UIDevice.current.userInterfaceIdiom == .pad {
            appDelegate.selected = playerId
        }
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    // MARK: Actions

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVolumeView" {
            segue.destination.popoverPresentationController?.sourceRect = volumeButton.frame
            if let volumePopOverViewController = segue.destination as? VolumePopOverViewController,
            let sonosVolume = player as? VolumeProtocol {
                volumePopOver = volumePopOverViewController
                volumePopOver?.sonosVolume = sonosVolume

                volumePopOver?.preferredContentSize = CGSize(width: (UIDevice.current.userInterfaceIdiom == .pad) ?
                    self.wholeView.frame.width/2 : self.wholeView.frame.width, height: 100)

                if let controller = volumePopOver?.popoverPresentationController {
                    controller.delegate = self
                }
            }
        }
    }

    @IBAction func volumeButtonPressed(_ sender: AnyObject) {
        if let player = self.player, player.isConnected() {
            performSegue(withIdentifier: "showVolumeView", sender: self)
        }
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        guard let p = player else { return }
        p.isPlaying ? p.pause() : p.play()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        player?.goToPreviousTrack()
    }

    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        player?.goToNextTrack()
    }
    func onGroupVolume(_ muted: Bool?, fixed: Bool?, volume: Int?) {
       
    }
}

class GradientView: UIView {

    override class var layerClass : AnyClass {
        return CAGradientLayer.self
    }

    func generateGradient(_ topColor: UIColor, _ bottomColor: UIColor) {

        guard let gradientLayer = self.layer as? CAGradientLayer else {
            return
        }

        gradientLayer.frame = self.bounds
        gradientLayer.colors = [ topColor.cgColor, bottomColor.cgColor ]
    }
}

extension String {

    /**
     * Returns a string trimmed up to the given `limit` and appended with an ellipsis.
     * - parameter limit: If the string is larger than `limit` it will be trimmed
     * - returns: Trimmed string with ellipsis appended.
     */
    func trimToWidth(_ frame: CGRect, percentFill: Float) -> String {

        var trimmed = self

        let width = frame.width * CGFloat(percentFill)

        let stringSize: CGSize = self.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20.0)])
        if width <= stringSize.width {
            let limit = width/stringSize.width
            let newSize = Float(limit) * Float(self.characters.count) - 3
            trimmed = self.substring(with: (self.startIndex ..< self.characters.index(self.startIndex, offsetBy: Int(newSize)))) + "..."
        }

        return trimmed
    }
}
