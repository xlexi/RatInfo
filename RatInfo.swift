

import Foundation
import Cocoa

class RatInfo: NSObject, THOPluginProtocol {
    let token = ""
    
    func pluginLoadedIntoMemory() {
        masterController().mainWindow.selectedClient?.printDebugInformation("RatInfo Loaded")
        NSLog("RatInfo Loaded")
    }
    
    var subscribedUserInputCommands: [String] {
        return ["ratinfo"]
    }
    
    func userInputCommandInvoked(on client: IRCClient, command commandString: String, messageString: String) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let nickname = messageString.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            client.printDebugInformation("Invalid nickname")
            return
        }
        let url = URL(string: "https://api.fuelrats.com/nicknames/search/\(nickname)")
        var request = URLRequest(url: url!)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            print("loaded")
            if (error == nil) {
                guard data != nil else {
                    return
                }
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                    if let results = json?["data"] as? [AnyObject] {
                        if results.count > 0 {
                            guard let result = results[0] as? [String: AnyObject] else {
                                client.printDebugInformation("Unable to parse user")
                                return
                            }
                            guard let user = User(data: result) else {
                                client.printDebugInformation("Unable to parse user")
                                return
                            }
                            
                            client.printDebugInformation("Rat Information for \(user.email) (id: \(user.id))")
                            
                            var earliestRat: Rat?
                            if (user.rats.count > 0) {
                                earliestRat = user.rats.reduce(user.rats[0], {
                                    $1.createdAt < $0.createdAt ? $1 : $0
                                })
                            }
                            
                            let joined = earliestRat?.joined ?? user.createdAt
                            client.printDebugInformation("Joined: \(joined)")
                            
                            var permissions = "Permissions: \(user.group)"
                            if (user.drilled) {
                                permissions += " (Rat Drilled)"
                            }
                            
                            if (user.drilledDispatch) {
                                permissions += " (Dispatch Drilled)"
                            }
                            client.printDebugInformation(permissions)
                            client.printDebugInformation("Nicknames: \(user.nicknames.joined(separator: ", "))")
                            client.printDebugInformation("Commanders:")
                            
                            for rat in user.rats {
                                client.printDebugInformation("Name: \"\(rat.name)\" Platform: \(rat.platform) id: \(rat.id)")
                            }
                            
                        } else {
                            client.printDebugInformation("No users found for this nickname")
                        }
                    } else {
                        client.printDebugInformation("Invalid response")
                    }
                }
            }
            else {
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()

    }
}
