import SwiftUI
import SwiftData

struct ContentView: View {
    let container: ModelContainer
    
    var body: some View {
        TabView {
            TodayView(container: container)
                .tabItem {
                    Label("Hoy", systemImage: "calendar.today")
                }
            
            Text("Vista de Calendario (Próximamente)")
                .tabItem {
                    Label("Calendario", systemImage: "calendar")
                }
            
            Text("Vista de Configuración (Próximamente)")
                .tabItem {
                    Label("Configuración", systemImage: "gear")
                }
        }
    }
}

