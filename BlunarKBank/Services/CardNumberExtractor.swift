import Foundation

enum CardNumberExtractor {
    /// Extrae únicamente números de tarjeta. Prioriza tarjetas cubanas RED que comienzan por 92.
    static func extract(from payload: String) -> String? {
        let normalized = payload.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let candidates = matches(in: payload) + slidingCandidates(in: normalized)
        if let cuban = candidates.first(where: { $0.count == 16 && $0.hasPrefix("92") }) { return cuban }
        return candidates.first(where: { $0.count == 16 })
    }

    private static func matches(in text: String) -> [String] {
        let pattern = #"(?<!\d)(?:\d[ -]?){15}\d(?!\d)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let range = NSRange(text.startIndex..., in: text)
        return regex.matches(in: text, range: range).compactMap { match in
            guard let r = Range(match.range, in: text) else { return nil }
            return String(text[r]).filter(\.isNumber)
        }
    }

    private static func slidingCandidates(in digits: String) -> [String] {
        guard digits.count >= 16 else { return [] }
        var result: [String] = []
        for i in 0...(digits.count - 16) {
            let start = digits.index(digits.startIndex, offsetBy: i)
            let end = digits.index(start, offsetBy: 16)
            result.append(String(digits[start..<end]))
        }
        return result
    }
}
