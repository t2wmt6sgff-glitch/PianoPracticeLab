 import SwiftUI
import SwiftData

struct CalendarView: View {
    let container: ModelContainer
    var context: ModelContext { ModelContext(container) }
    
    @State private var mesActual: Date = Date()
    @State private var diaSeleccionado: Date?
    
    @Query(sort: \StudySchedule.id) private var schedules: [StudySchedule]
    @Query(sort: \PracticeSession.date) private var todasSesiones: [PracticeSession]
    @Query(sort: \DayJustification.date) private var todasJustificaciones: [DayJustification]
    
    var schedule: StudySchedule? { schedules.first }
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Navegación de mes
                HStack {
                    Button(action: mesAnterior) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Text(nombreMes(mesActual))
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: mesSiguiente) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                // Encabezados de días
                HStack {
                    ForEach(["D", "L", "M", "X", "J", "V", "S"], id: \.self) { dia in
                        Text(dia)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                // Grilla de días
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    ForEach(diasDelMes(), id: \.self) { dia in
                        if let fecha = dia {
                            DiaCalendarioView(
                                fecha: fecha,
                                estado: estadoParaFecha(fecha),
                                esHoy: calendar.isDateInToday(fecha),
                                esSeleccionado: esSeleccionado(fecha)
                            )
                            .onTapGesture {
                                diaSeleccionado = fecha
                            }
                        } else {
                            Color.clear
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Leyenda
                LeyendaView()
                
                Spacer()
            }
            .navigationTitle("Calendario")
            .sheet(item: Binding(
                get: { diaSeleccionado.map { FechaIdentificable(date: $0) } },
                set: { diaSeleccionado = $0?.date }
            )) { fecha in
                DetalleDiaView(
                    fecha: fecha.date,
                    schedule: schedule,
                    sesiones: sesionesParaFecha(fecha.date),
                    justificacion: justificacionParaFecha(fecha.date)
                )
            }
        }
    }
    
    // MARK: - Navegación
    
    private func mesAnterior() {
        if let nuevoMes = calendar.date(byAdding: .month, value: -1, to: mesActual) {
            mesActual = nuevoMes
        }
    }
    
    private func mesSiguiente() {
        if let nuevoMes = calendar.date(byAdding: .month, value: 1, to: mesActual) {
            mesActual = nuevoMes
        }
    }
    
    // MARK: - Cálculos de calendario
    
    private func nombreMes(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date).capitalized
    }
    
    private func diasDelMes() -> [Date?] {
        guard let intervaloMes = calendar.dateInterval(of: .month, for: mesActual) else {
            return []
        }
        
        let primerDiaDelMes = intervaloMes.start
        let diasEnMes = calendar.range(of: .day, in: .month, for: mesActual)?.count ?? 30
        
        // Día de la semana del primer día (1 = domingo, 2 = lunes, etc.)
        let weekdayPrimerDia = calendar.component(.weekday, from: primerDiaDelMes)
        
        var dias: [Date?] = []
        
        // Añadir espacios vacíos antes del primer día
        for _ in 1..<weekdayPrimerDia {
            dias.append(nil)
        }
        
        // Añadir todos los días del mes
        for dia in 1...diasEnMes {
            if let fecha = calendar.date(byAdding: .day, value: dia - 1, to: primerDiaDelMes) {
                dias.append(fecha)
            }
        }
        
        return dias
    }
    
    // MARK: - Cálculo de estados
    
    private func estadoParaFecha(_ date: Date) -> DayStatus {
        let sesiones = sesionesParaFecha(date)
        let justificacion = justificacionParaFecha(date)
        
        return calcularEstado(
            for: date,
            schedule: schedule,
            sesionesDelDia: sesiones,
            justificacionDelDia: justificacion
        )
    }
    
    private func sesionesParaFecha(_ date: Date) -> [PracticeSession] {
        todasSesiones.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private func justificacionParaFecha(_ date: Date) -> DayJustification? {
        todasJustificaciones.filter { calendar.isDate($0.date, inSameDayAs: date) }.first
    }
    
    private func esSeleccionado(_ date: Date) -> Bool {
        guard let seleccionado = diaSeleccionado else { return false }
        return calendar.isDate(date, inSameDayAs: seleccionado)
    }
}

// MARK: - Vista de día individual en el calendario

struct DiaCalendarioView: View {
    let fecha: Date
    let estado: DayStatus
    let esHoy: Bool
    let esSeleccionado: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: fecha))")
                .font(.body)
                .fontWeight(esHoy ? .bold : .regular)
            
            // Indicador de estado (no solo color)
            Circle()
                .fill(colorParaEstado(estado))
                .frame(width: 8, height: 8)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(esSeleccionado ? Color.accentColor.opacity(0.2) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(esHoy ? Color.accentColor : Color.clear, lineWidth: 2)
        )
    }
    
    private func colorParaEstado(_ estado: DayStatus) -> Color {
        switch estado {
        case .practiced: return .green
        case .pending: return .orange
        case .plannedRest: return .blue
        case .notPracticed: return .red.opacity(0.7)
        case .justified: return .yellow
        }
    }
}

// MARK: - Leyenda

struct LeyendaView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Estados")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                LeyendaItem(color: .green, texto: "Practicado")
                LeyendaItem(color: .orange, texto: "Pendiente")
                LeyendaItem(color: .blue, texto: "Descanso")
                LeyendaItem(color: .red.opacity(0.7), texto: "No practicado")
                LeyendaItem(color: .yellow, texto: "Justificado")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct LeyendaItem: View {
    let color: Color
    let texto: String
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(texto)
                .font(.caption)
        }
    }
}

// MARK: - Vista de detalle de día

struct DetalleDiaView: View {
    let fecha: Date
    let schedule: StudySchedule?
    let sesiones: [PracticeSession]
    let justificacion: DayJustification?
    
    @Environment(\.dismiss) var dismiss
    
    private let calendar = Calendar.current
    
    var estado: DayStatus {
        calcularEstado(
            for: fecha,
            schedule: schedule,
            sesionesDelDia: sesiones,
            justificacionDelDia: justificacion
        )
    }
    
    var minutosTotales: Int {
        sesiones.reduce(0) { $0 + $1.durationMinutes }
    }
    
    var minimoRequerido: Int {
        sesiones.last?.minimumDurationMinutesAtRecording 
        ?? schedule?.minimumDurationMinutes ?? 15
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Encabezado
                    VStack(alignment: .leading, spacing: 8) {
                        Text(nombreFecha(fecha))
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(estado.rawValue)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(colorParaEstado(estado))
                    }
                    
                    Divider()
                    
                    // Contenido según estado
                    switch estado {
                    case .practiced:
                        contenidoPracticado()
                    case .pending:
                        contenidoPendiente()
                    case .plannedRest:
                        contenidoDescanso()
                    case .notPracticed:
                        contenidoNoPracticado()
                    case .justified:
                        contenidoJustificado()
                    }
                }
                .padding()
            }
            .navigationTitle("Detalle del día")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }
    
    // MARK: - Contenido por estado
    
    @ViewBuilder
    private func contenidoPracticado() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(minutosTotales) minutos practicados")
                .font(.body)
            
            Text("Mínimo: \(minimoRequerido) minutos")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if !sesiones.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sesiones:")
                        .font(.headline)
                    
                    ForEach(sesiones) { sesion in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(sesion.durationMinutes) minutos")
                                .font(.body)
                            
                            if let nota = sesion.note, !nota.isEmpty {
                                Text(nota)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func contenidoPendiente() -> some View {
        Text("Mínimo: \(minimoRequerido) minutos")
            .font(.body)
    }
    
    @ViewBuilder
    private func contenidoDescanso() -> some View {
        Text("Hoy no es un día previsto de estudio.")
            .font(.body)
    }
    
    @ViewBuilder
    private func contenidoNoPracticado() -> some View {
        Text("No se registró una práctica suficiente.")
            .font(.body)
    }
    
    @ViewBuilder
    private func contenidoJustificado() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ausencia justificada.")
                .font(.body)
            
            if let nota = justificacion?.note, !nota.isEmpty {
                Text(nota)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func nombreFecha(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "d 'de' MMMM"
        return formatter.string(from: date)
    }
    
    private func colorParaEstado(_ estado: DayStatus) -> Color {
        switch estado {
        case .practiced: return .green
        case .pending: return .orange
        case .plannedRest: return .blue
        case .notPracticed: return .red.opacity(0.7)
        case .justified: return .yellow
        }
    }
}

// MARK: - Helper para Identifiable

struct FechaIdentificable: Identifiable {
    let id = UUID()
    let date: Date
}


