import Foundation

protocol ShowsLocalDataSource: Sendable {
    func loadPage(_ page: Int) async throws -> ShowsPageCacheRecord?
    func savePage(_ record: ShowsPageCacheRecord, page: Int) async throws
    func loadDetail(id: Int) async throws -> ShowDetailCacheRecord?
    func saveDetail(_ record: ShowDetailCacheRecord, id: Int) async throws
}

actor FileShowsLocalDataSource: ShowsLocalDataSource {
    private let directoryURL: URL
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(directoryURL: URL, fileManager: FileManager = .default) {
        self.directoryURL = directoryURL
        self.fileManager = fileManager

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func loadPage(_ page: Int) async throws -> ShowsPageCacheRecord? {
        try load(ShowsPageCacheRecord.self, from: pageURL(page))
    }

    func savePage(_ record: ShowsPageCacheRecord, page: Int) async throws {
        try save(record, to: pageURL(page))
    }

    func loadDetail(id: Int) async throws -> ShowDetailCacheRecord? {
        try load(ShowDetailCacheRecord.self, from: detailURL(id))
    }

    func saveDetail(_ record: ShowDetailCacheRecord, id: Int) async throws {
        try save(record, to: detailURL(id))
    }

    private func load<Value: Decodable>(_ type: Value.Type, from url: URL) throws -> Value? {
        guard fileManager.fileExists(atPath: url.path) else {
            return nil
        }
        return try decoder.decode(type, from: Data(contentsOf: url))
    }

    private func save<Value: Encodable>(_ value: Value, to url: URL) throws {
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try encoder.encode(value).write(to: url, options: .atomic)
    }

    private func pageURL(_ page: Int) -> URL {
        directoryURL.appendingPathComponent("page-\(page).json")
    }

    private func detailURL(_ id: Int) -> URL {
        directoryURL.appendingPathComponent("detail-\(id).json")
    }
}
