import Foundation
import Datasource
import FeedKit

public class Basel: Datasource {
    public let name = "Basel"
    public let slug = "basel"
    public let infoURL = URL(string: "http://www.parkleitsystem-basel.ch/status.php")!

    public var contributor: String? = "Immobilien Basel-Stadt"
    public var attributionURL: URL? = URL(string: "http://www.parkleitsystem-basel.ch/impressum.php")!
    public var license: String? = "Creative-Commons-Null-Lizenz (CC-0)"

    let feedURL = URL(string: "https://www.parkleitsystem-basel.ch/rss_feed.php")!

    public init() {}

    public func data() throws -> DataPoint {
        let (data, _) = try get(url: self.feedURL)
        let parser = FeedParser(data: data)
        let result = parser.parse()
        guard let feed = result.rssFeed else {
            throw OpenParkingError.decoding(description: "Failed to decode RSS Feed", underlyingError: result.error)
        }

        guard let items = feed.items else {
            throw OpenParkingError.decoding(description: "No items found", underlyingError: nil)
        }

        let lots = try items.map(parse(item:))
        return DataPoint(lots: lots)
    }

    func parse(item: RSSFeedItem) throws -> LotResult {
        guard
            let name = item.title?.removingHTMLEntities,
            let link = item.link,
            let detailURL = URL(string: link),
            let desc = item.description
        else {
            throw OpenParkingError.decoding(description: "RSS feed item missing title, link or description", underlyingError: nil)
        }

        guard let metadata = geodata.lot(withName: name) else {
            return .failure(.missingMetadata(lot: name))
        }

        let freeRegex = Regex("Anzahl.+: (\\d+)")
        guard
            let freeStr = freeRegex.firstMatch(in: desc)?.captures[0],
            let available = Int(freeStr)
        else {
            throw OpenParkingError.decoding(description: "Missing free count in item description", underlyingError: nil)
        }

        var type: Lot.LotType = .structure
        if name.contains("Parkplatz") {
            type = .lot
        }

        guard let coordinates = metadata.coordinates else {
            return .failure(.missingMetadataField("coordinates", lot: name))
        }

        guard var capacity: Int = metadata.total else {
            return .failure(.missingMetadataField("total", lot: name))
        }

        // A few lots have weekday-specific total counts.
        if let totalByWeekday: [String: Int] = metadata.total_by_weekday {
            let weekday = Calendar(identifier: .gregorian).component(.weekday, from: Date())
            if let totalCount = totalByWeekday[String(weekday)] {
                capacity = totalCount
            }
        }

        return .success(Lot(dataAge: item.pubDate,
                            name: name,
                            coordinates: coordinates,
                            city: self.name,
                            region: nil,
                            address: metadata.address,
                            available: .discrete(available),
                            capacity: capacity,
                            state: .open,
                            type: type,
                            detailURL: detailURL))
    }
}
