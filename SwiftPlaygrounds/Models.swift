import Foundation
import SwiftData

// MARK: - Weekday

/// Día de la semana, alineado con Calendar.component(.weekday, from:)
/// donde 1 = domingo, 2 = lunes, ..., 7 = sábado.
enum Weekday: Int, Codable, CaseIterable, Identifiable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var id: Int { rawValue }
}

// MARK: - StudySchedule

/// Configuración del ritmo de estudio. Singleton lógico (una única instancia).
@Model
final class StudySchedule {
    var id: UUID
    var studyDays: [Weekday]
    var reminderHour: Int
    var reminderMinute: Int
    var minimumDurationMinutes: Int
    var remindersEnabled: Bool

    init(
        id: UUID = UUID(),
        studyDays: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday],
        reminderHour: Int = 18,
        reminderMinute: Int = 0,
        minimumDurationMinutes: Int = 15,
        remindersEnabled: Bool = false
    ) {
        self.id = id
        self.studyDays = studyDays
        self.reminderHour = reminderHour
        self.reminderMinute = reminderMinute
        self.minimumDurationMinutes = minimumDurationMinutes
        self.remindersEnabled = remindersEnabled
    }
}

// MARK: - PracticeSession

/// Una práctica registrada. Las sesiones de un mismo día se acumulan.
@Model
final class PracticeSession {
    var id: UUID
    var date: Date
    var durationMinutes: Int
    var note: String?
    /// Mínimo vigente en el momento de registrar la sesión.
    /// Nunca debe modificarse después de la creación.
    var minimumDurationMinutesAtRecording: Int

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        durationMinutes: Int,
        note: String? = nil,
        minimumDurationMinutesAtRecording: Int
    ) {
        self.id = id
        self.date = date
        self.durationMinutes = durationMinutes
        self.note = note
        self.minimumDurationMinutesAtRecording = minimumDurationMinutesAtRecording
    }
}

// MARK: - DayJustification

/// Una ausencia justificada para un día concreto.
@Model
final class DayJustification {
    var id: UUID
    var date: Date
    var note: String?

    init(
        id: UUID = UUID(),
        date: Date,
        note: String? = nil
    ) {
        self.id = id
        self.date = date
        self.note = note
    }
}
