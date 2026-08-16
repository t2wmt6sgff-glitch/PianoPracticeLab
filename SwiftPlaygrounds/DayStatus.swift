import Foundation
import SwiftData

enum DayStatus: String {
    case plannedRest = "Descanso planificado"
    case practiced = "Practicado"
    case pending = "Pendiente"
    case notPracticed = "No practicado"
    case justified = "Justificado"
}

// MARK: - Función generalizada para cualquier fecha

/// Calcula el estado de un día específico basándose en el horario, sesiones y justificaciones.
func calcularEstado(
    for date: Date,
    schedule: StudySchedule?,
    sesionesDelDia: [PracticeSession],
    justificacionDelDia: DayJustification?
) -> DayStatus {
    guard let schedule = schedule else { return .pending }
    
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)
    let esDiaDeEstudio = schedule.studyDays.contains { $0.rawValue == weekday }
    
    if !esDiaDeEstudio {
        return .plannedRest
    }
    
    let minutosTotales = sesionesDelDia.reduce(0) { $0 + $1.durationMinutes }
    let minimoRequerido = sesionesDelDia.last?.minimumDurationMinutesAtRecording 
    ?? schedule.minimumDurationMinutes
    
    if minutosTotales >= minimoRequerido {
        return .practiced
    }
    
    if justificacionDelDia != nil {
        return .justified
    }
    
    let hoy = calendar.startOfDay(for: Date())
    let diaEvaluado = calendar.startOfDay(for: date)
    
    if diaEvaluado < hoy {
        return .notPracticed
    } else {
        return .pending
    }
}

// MARK: - Función legacy para compatibilidad

func calcularEstadoHoy(
    schedule: StudySchedule?,
    sesionesHoy: [PracticeSession],
    justificacionHoy: DayJustification?
) -> DayStatus {
    return calcularEstado(
        for: Date(),
        schedule: schedule,
        sesionesDelDia: sesionesHoy,
        justificacionDelDia: justificacionHoy
    )
}

