import Foundation
import SwiftData

enum DayStatus: String {
    case plannedRest = "Descanso planificado"
    case practiced = "Practicado"
    case pending = "Pendiente"
    case notPracticed = "No practicado"
    case justified = "Justificado"
}

func calcularEstadoHoy(
    schedule: StudySchedule?,
    sesionesHoy: [PracticeSession],
    justificacionHoy: DayJustification?
) -> DayStatus {
    guard let schedule = schedule else { return .pending }
    
    let weekday = Calendar.current.component(.weekday, from: Date())
    let esDiaDeEstudio = schedule.studyDays.contains { $0.rawValue == weekday }
    
    if !esDiaDeEstudio {
        return .plannedRest
    }
    
    let minutosTotales = sesionesHoy.reduce(0) { $0 + $1.durationMinutes }
    // Si hay sesiones hoy, usamos el mínimo histórico de la más reciente. Si no, el del horario.
    let minimoRequerido = sesionesHoy.last?.minimumDurationMinutesAtRecording ?? schedule.minimumDurationMinutes
    
    if minutosTotales >= minimoRequerido {
        return .practiced
    }
    
    if justificacionHoy != nil {
        return .justified
    }
    
    return .pending
}


