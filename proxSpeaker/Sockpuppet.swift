//
//  Sockpuppet.swift
//  proxSpeaker
//
//  Created by Harrison Downs on 9/30/17.
//  Copyright © 2017 Harrison Downs. All rights reserved.
//

import Foundation

class Sockpuppet {
    private var addr : String
    private var port : Int
    private var buffer : [UInt8]
    private var inp : InputStream?
    private var out : OutputStream?
    private var inputStream : InputStream!
    private var outputStream : OutputStream!
    
    
    init(a : String, p : Int){
        addr = a
        port = p
        buffer = [UInt8]()
        
        Stream.getStreamsToHost(withName: addr, port: port, inputStream: &inp, outputStream: &out)
        inputStream = inp!
        outputStream = out!
        inputStream.open()
        outputStream.open()
        
        
    }

    /* write to the socket */
    func write(outputString : String){
        let asUInt8Array = String(outputString.characters).utf8.map{ UInt8($0) }
        for c in asUInt8Array{
            buffer.append(c);
        }
        outputStream.write(&buffer, maxLength: buffer.count)
        
        buffer.removeAll()
    }
    
    /* read from the socket */
    func read() -> String{
        var readByte :UInt8 = 0
        var buff = [UInt8]()
        while inputStream.hasBytesAvailable {
            inputStream.read(&readByte, maxLength: 1)
            buff.append(readByte)
        }
        
        return String(bytes: buff, encoding: String.Encoding.utf8)!
        
    }
   
    

    
}
