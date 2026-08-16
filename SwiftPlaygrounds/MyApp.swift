import SwiftUI
import SwiftData

@main
struct MyApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                StudySchedule.self,
                PracticeSession.self,
                DayJustification.self
            ])
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            // Fallback: si falla la creación, usamos un container en memoria
            // Esto nunca debería ocurrir en condiciones normales
            container = try! ModelContainer(
                for: Schema([
                    StudySchedule.self,
                    PracticeSession.self,
                    DayJustification.self
                ]),
                configurations: [ModelConfiguration(isStoredInMemoryOnly: true)]
            )
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}

