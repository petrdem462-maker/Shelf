import Foundation

struct WorkDetail: Decodable, Sendable {
    let title: String
    let description: String?
    let subjects: [String]

    private enum CodingKeys: String, CodingKey {
        case title, description, subjects
    }

    private struct TextValue: Decodable {
        let value: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subjects = try container.decodeIfPresent([String].self, forKey: .subjects) ?? []

        if let text = try? container.decode(String.self, forKey: .description) {
            description = text
        } else if let object = try? container.decode(TextValue.self, forKey: .description) {
            description = object.value
        } else {
            description = nil
        }
    }
}

struct RatingsResponse: Decodable, Sendable {
    struct Summary: Decodable, Sendable {
        let average: Double?
        let count: Int
    }
    let summary: Summary
}

