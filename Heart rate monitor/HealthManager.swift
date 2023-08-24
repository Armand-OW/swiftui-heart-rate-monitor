//
//  HealthManager.swift
//  Heart rate monitor
//
//  Created by OW on 2023/08/21.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject{
    
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit.count().unitDivided(by: .minute())

    @Published var value = 0
    
    init(){
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    
    func autorizeHealthKit() {
          
          // Used to define the identifiers that create quantity type objects.
            let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
         // Requests permission to save and read the specified data types.
            healthStore.requestAuthorization(toShare: nil, read: healthKitTypes) { (success, error) in
                if success {
                    print("HealthKit authorization succeeded.")
                    // Start your queries here
                } else {
                    print("HealthKit authorization failed. Error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        print("Heart Rate Query Started...")
        
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = { query, samples, _, _, error in
            
            if let error = error {
                print("Error in query update handler: \(error.localizedDescription)")
                return
            }
            
            guard let samples = samples as? [HKQuantitySample] else {
                print("No heart rate samples found.")
                return
            }
            
            print("SAMPLES: \(samples)")
            
            self.process(samples, type: quantityTypeIdentifier)
        }
        
        let query = HKAnchoredObjectQuery(
            type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit,
            resultsHandler: updateHandler
        )
        
        query.updateHandler = updateHandler
        
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        print("Process Started...")
            // variable initialization
            var lastHeartRate = 0.0
            
            // cycle and value assignment
        for sample in samples {
            if type == .heartRate {
                let sampleHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
                print("Heart rate \(sampleHeartRate)")
                
                if sampleHeartRate > lastHeartRate {
                    lastHeartRate = sampleHeartRate
                    print("Last Heart Rate: \(lastHeartRate)")
                    self.value = Int(lastHeartRate)
                }
            } else {
                print("NOPE..")
            }
        }
    }
}
