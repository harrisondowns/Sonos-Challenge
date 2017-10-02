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
        sock = Sockpuppet(a: "127.0.0.1", p: 56565)//10.244.140.22", p: 56565)
        
    }
    
    @IBAction func sendHello(){
        sock.write(outputString: "hullo\n")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startSocket()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

