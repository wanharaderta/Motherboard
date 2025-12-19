//
//  EmergencyMedicationModelRequest.swift
//  Motherboard
//
//  Created by Wanhar on 17/12/25.
//

struct EmergencyMedicationModelRequest: Codable {
    var autoInjectorBrand: String?
    var emergencyDose: MedicationDose?
    var whenToAdminister: String?
    var followUpSteps: String?
    var instructionalYouTubeLink: String?
    var doctorContact: String?
    var kidID: String?
}
