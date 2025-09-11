import Foundation

enum AppDateFormatter {
    static let shared: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"
        df.timeZone = .current
        return df
    }()
}
