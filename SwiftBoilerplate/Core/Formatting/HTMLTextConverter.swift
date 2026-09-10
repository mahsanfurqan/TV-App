import Foundation
import UIKit

enum HTMLTextConverter {
    static func attributedString(from html: String?) -> AttributedString? {
        guard let html, !html.isEmpty,
              let data = html.data(using: .utf8),
              let value = try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
              ) else {
            return nil
        }

        let sanitized = NSMutableAttributedString(attributedString: value)
        sanitized.removeAttribute(
            .foregroundColor,
            range: NSRange(location: 0, length: sanitized.length)
        )
        return AttributedString(sanitized)
    }

    static func plainText(from html: String?) -> String {
        guard let html, !html.isEmpty else {
            return ""
        }

        if let attributed = attributedString(from: html) {
            return String(attributed.characters)
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return html
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
