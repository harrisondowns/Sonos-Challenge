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
        sock = Sockpuppet(a: "127.0.0.1", p: 56565)
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
    
    func socketsForDays(){
        let addr = "127.0.0.1"
        let port = 56565
        
      
        var inp :InputStream?
        var out :OutputStream?
        var buffer : [UInt8] = [20, 32, 64, 80]
        Stream.getStreamsToHost(withName: addr, port: port, inputStream: &inp, outputStream: &out)
        let inputStream = inp!
        let outputStream = out!
        inputStream.open()
        outputStream.open()
        
        var readByte :UInt8 = 0
        while inputStream.hasBytesAvailable {
            inputStream.read(&readByte, maxLength: 1)
        }
        
        // buffer is a UInt8 array containing bytes of the string "Jonathan Yaniv.".
        outputStream.write(&buffer, maxLength: buffer.count)
    }
    


}

