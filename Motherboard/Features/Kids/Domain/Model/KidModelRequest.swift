//
//  KidModelRequest.swift
//  Motherboard
//
//  Created by Wanhar on 12/12/25.
//
import Foundation

struct KidModelRequest: Codable {
    var fullname: String?
    var nickname: String?
    var dob: Date?
    var gender: Gender?
    var photoUrl: String?
    var notes: String?
}
