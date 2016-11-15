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

struct User {
    let id: String
    let createdAt: Date
    let updatedAt: Date
    let email: String
    let drilled: Bool
    let drilledDispatch: Bool
    let group: String
    
    let nicknames: [String]
    let rats: [Rat]
}

extension User {
    init?(data: [String: AnyObject]) {
        guard
            let createdAtString = data["createdAt"] as? String,
            let updatedAtString = data["updatedAt"] as? String else {
                return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        guard
            let id = data["id"] as? String,
            let createdAt = dateFormatter.date(from: createdAtString),
            let updatedAt = dateFormatter.date(from: updatedAtString),
            let email = data["email"] as? String,
            let drilled = data["drilled"] as? Bool,
            let drilledDispatch = data["drilledDispatch"] as? Bool,
            let group = data["group"]  as? String,
            let nicknames = data["nicknames"] as? [String] else {
                return nil
        }
        
        
        
        var rats: [Rat] = []
        
        if let ratsJson = data["rats"] as? [[String: AnyObject]] {
            for ratData in ratsJson {
                if let rat = Rat(data: ratData) {
                    rats.append(rat)
                }
            }
        }
        
        
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.email = email
        self.drilled = drilled
        self.drilledDispatch = drilledDispatch
        self.group = group
        self.nicknames = nicknames
        self.rats = rats
    }
}
