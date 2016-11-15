/*
 Copyright (c) 2016, Alex S. Glomsaas
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Foundation
import Cocoa

struct Rat {
    
    let id: String
    let name: String
    let data: [String: AnyObject]?
    let joined: Date
    let platform: Platform
    let createdAt: Date
    let updatedAt: Date
}

extension Rat {
    init?(data: [String: AnyObject]) {
        guard
            let joinedString = data["joined"] as? String,
            let createdAtString = data["createdAt"] as? String,
            let updatedAtString = data["updatedAt"] as? String,
            let platformString = data["platform"] as? String
        else {
                return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        guard
            let id = data["id"] as? String,
            let name = data["CMDRname"] as? String,
            let joined = dateFormatter.date(from: joinedString),
            let platform = Platform(rawValue: platformString.uppercased()),
            let createdAt = dateFormatter.date(from: createdAtString),
            let updatedAt = dateFormatter.date(from: updatedAtString)
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.data = data["data"] as? [String: AnyObject]
        self.joined = joined
        self.platform = platform
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum Platform: String {
    case PC
    case XB
}

