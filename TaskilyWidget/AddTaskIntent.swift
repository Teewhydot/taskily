import AppIntents
import UIKit


struct AddTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "New Task"
    static var openAppWhenRun: Bool = true // ← tells system to open your app
    
    
    
    @MainActor
    func perform() async throws -> some IntentResult {
        // Do NOT create a task here – just let the app open.
        // The app will read a "should add task" flag or URL parameters.
        return .result()
    }
}
