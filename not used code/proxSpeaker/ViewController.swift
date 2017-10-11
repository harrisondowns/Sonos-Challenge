//
//  ViewController.swift
//  proxSpeaker
//
//  Created by Harrison Downs on 9/29/17.
//  Copyright © 2017 Harrison Downs. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    
    var sock : Sockpuppet!
    
    func startSocket(){
        sock = Sockpuppet(a: "172.20.10.3", p: 56565)//10.244.140.22", p: 56565)
        
    }
    
    func grabTime(){
        let d = Date().timeIntervalSince1970
        let url = URL(string: "https://sonos-challenge.herokuapp.com/sensor1.txt?" + String(d))
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            print(String(data: data, encoding: String.Encoding.utf8) as String!)
            // let json = try! JSONSerialization.jsonObject(with: data, options: [])
            //print(json)
        
        }
        
        task.resume()
    }
    
    @IBAction func readHello(){
      //  print(sock.read())
        grabTime()
    }
    
    @IBAction func sendHello(){
        sock.write(outputString: "hullo\n")
        print(sock.read())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(rip)), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
        startSocket()
    }

    func rip(){
        print("yo")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

