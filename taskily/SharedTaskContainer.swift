import SwiftData
import Foundation

enum SharedModelContainer {
    static let shared: ModelContainer = {
        let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.ng.com.sirteefyapps.taskily"
        )!
        let storeURL = groupURL.appendingPathComponent("tasks.sqlite")
        let configuration = ModelConfiguration(url: storeURL)
        
        do {
            return try ModelContainer(for: TaskModel.self, configurations: configuration)
        } catch {
            fatalError("Failed to create shared model container: \(error)")
        }
    }()
}
