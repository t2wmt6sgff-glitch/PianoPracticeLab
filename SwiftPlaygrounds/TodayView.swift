import SwiftUI
import SwiftData

struct TodayView: View {
    let container: ModelContainer
    var context: ModelContext { ModelContext(container) }
    
    @State private var showingAddSession = false
    
    @Query(sort: \StudySchedule.id) private var schedules: [StudySchedule]
    @Query(sort: \PracticeSession.date) private var todasSesiones: [PracticeSession]
    @Query(sort: \DayJustification.date) private var todasJustificaciones: [DayJustification]
    
    var schedule: StudySchedule? { schedules.first }
    
    // Filtrado manual en memoria (seguro para iOS 17)
    var sesionesHoy: [PracticeSession] {
        todasSesiones.filter { Calendar.current.isDate($0.date, inSameDayAs: Date()) }
    }
    
    var justificacionesHoy: [DayJustification] {
        todasJustificaciones.filter { Calendar.current.isDate($0.date, inSameDayAs: Date()) }
    }
    
    var estado: DayStatus {
        calcularEstadoHoy(
            schedule: schedule,
            sesionesHoy: sesionesHoy,
            justificacionHoy: justificacionesHoy.first
        )
    }
    
    var minutosTotales: Int {
        sesionesHoy.reduce(0) { $0 + $1.durationMinutes }
    }
    
    var minimoRequerido: Int {
        sesionesHoy.last?.minimumDurationMinutesAtRecording ?? (schedule?.minimumDurationMinutes ?? 15)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text(estado.rawValue)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(colorForEstado(estado))
                    
                    if estado != .plannedRest {
                        Text("\(minutosTotales) / \(minimoRequerido) minutos")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 40)
                
                if estado == .pending || estado == .notPracticed {
                    Button(action: { showingAddSession = true }) {
                        Text("Registrar práctica")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 32)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Hoy")
            .task {
                // Garantiza que exista un horario por defecto si es la primera vez
                if schedules.isEmpty {
                    let nuevo = StudySchedule(
                        studyDays: [.monday, .tuesday, .wednesday, .thursday, .friday],
                        reminderHour: 18,
                        reminderMinute: 0,
                        minimumDurationMinutes: 15,
                        remindersEnabled: false
                    )
                    context.insert(nuevo)
                    try? context.save()
                }
            }
            .sheet(isPresented: $showingAddSession) {
                AddSessionView(
                    container: container,
                    defaultDuration: minimoRequerido,
                    onSaved: { showingAddSession = false }
                )
            }
        }
    }
    
    private func colorForEstado(_ estado: DayStatus) -> Color {
        switch estado {
        case .practiced: return .green
        case .pending: return .orange
        case .plannedRest: return .blue
        case .notPracticed: return .red
        case .justified: return .yellow
        }
    }
}

// MARK: - Vista de Registro de Práctica
struct AddSessionView: View {
    let container: ModelContainer
    var context: ModelContext { ModelContext(container) }
    let defaultDuration: Int
    let onSaved: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var duration: Int
    @State private var note: String
    
    init(container: ModelContainer, defaultDuration: Int, onSaved: @escaping () -> Void) {
        self.container = container
        self.defaultDuration = defaultDuration
        self._duration = State(initialValue: defaultDuration)
        self._note = State(initialValue: "")
        self.onSaved = onSaved
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Duración") {
                    Stepper("\(duration) minutos", value: $duration, in: 5...120, step: 5)
                }
                Section("Nota (opcional)") {
                    TextField("¿Cómo fue la práctica?", text: $note)
                }
            }
            .navigationTitle("Nueva Práctica")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let session = PracticeSession(
                            date: Date(),
                            durationMinutes: duration,
                            note: note.isEmpty ? nil : note,
                            minimumDurationMinutesAtRecording: defaultDuration
                        )
                        context.insert(session)
                        try? context.save()
                        onSaved()
                    }
                }
            }
        }
    }
}

