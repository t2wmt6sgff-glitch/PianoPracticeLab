import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var testResult = "Ejecutando prueba…"

    var body: some View {
        VStack(spacing: 16) {
            Text("Prueba de persistencia")
                .font(.title)
            Text(testResult)
                .multilineTextAlignment(.center)
                .padding()
        }
        .task { runPersistenceTest() }
    }

    private func runPersistenceTest() {
        // 1. Crear un StudySchedule con varios Weekday
        let schedule = StudySchedule(
            studyDays: [.monday, .wednesday, .friday],
            reminderHour: 19,
            reminderMinute: 30,
            minimumDurationMinutes: 20,
            remindersEnabled: true
        )

        // 2. Guardar
        modelContext.insert(schedule)
        do { try modelContext.save() }
        catch {
            testResult = "❌ Error al guardar: \(error)"
            return
        }

        // 3. Recuperar
        do {
            let fetched = try modelContext.fetch(FetchDescriptor<StudySchedule>())
            guard let recovered = fetched.first else {
                testResult = "❌ No se recuperó ningún StudySchedule."
                return
            }

            // 4. Comprobar valores
            let expected: [Weekday] = [.monday, .wednesday, .friday]
            let ok = recovered.studyDays == expected
                && recovered.reminderHour == 19
                && recovered.reminderMinute == 30
                && recovered.minimumDurationMinutes == 20
                && recovered.remindersEnabled == true

            testResult = ok
                ? "✅ ÉXITO: [Weekday] persiste correctamente.\nDías: \(recovered.studyDays)"
                : "❌ FALLO: los valores no coinciden.\nDías: \(recovered.studyDays)"
        } catch {
            testResult = "❌ Error al recuperar: \(error)"
        }
    }
}
