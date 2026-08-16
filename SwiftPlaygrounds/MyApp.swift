import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            StudySchedule.self,
            PracticeSession.self,
            DayJustification.self
        ])
    }
}
