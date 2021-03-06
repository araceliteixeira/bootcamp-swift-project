//
//  Person.swift
//  Course Project
//
//  Created by Araceli Teixeira on 15/12/17.
//  Copyright © 2017 ProDigi. All rights reserved.
//

import UIKit

class User: Person {
    public let gender: String
    public let cell: String
    public let address: String
    public let country: String
    public let iconURL: String
    public var icon: UIImage?
    
    init(_ firstName: String, _ lastName: String, _ email: String, _ gender: String, _ cell: String, _ address: String, _ country: String, _ iconURL: String) {
        self.gender = gender
        self.cell = cell
        self.address = address
        self.country = country
        self.iconURL = iconURL
        
        super.init(firstName: firstName, lastName: lastName, email: email)
        
        loadImage()
    }
    
    public func fullAddress() -> String {
        let separator = ", "
        return address + separator + country
    }
}

extension User {
    private func loadImage() {
        guard let iconURL = URL(string: iconURL) else {
            print("Error: Not possible to create the URL object")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let semaphore = DispatchSemaphore(value: 0)
        (session.dataTask(with: iconURL) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                    else {
                        print("Error: Error on fetch.")
                        return
                }
                
                if let data = data {
                    self.icon = UIImage(data: data)
                } else {
                    print("Error: Data is null")
                }
                semaphore.signal()
            }
        }).resume()
        semaphore.wait()
    }
}
