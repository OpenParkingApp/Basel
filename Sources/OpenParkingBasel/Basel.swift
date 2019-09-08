import Foundation
import OpenParkingBase
import FeedKit
import Regex

public class Basel: Datasource {
    public let name = "Basel"
    public let slug = "basel"
    public let infoUrl = URL(string: "http://www.parkleitsystem-basel.ch/status.php")!

    public var contributor: String? = "Immobilien Basel-Stadt"
    public var attributionURL: URL? = URL(string: "http://www.parkleitsystem-basel.ch/impressum.php")!
    public var license: String? = "Creative-Commons-Null-Lizenz (CC-0)"

    let feedURL = URL(string: "http://www.parkleitsystem-basel.ch/rss_feed.php")!

    public init() {}

    public func data() throws -> DataPoint {
        let (data, _) = try get(url: self.feedURL)
        let parser = FeedParser(data: data)
        let result = parser.parse()
        guard let feed = result.rssFeed else {
            throw OpenParkingError.decoding(description: "Failed to decode RSS Feed", underlyingError: result.error)
        }

        guard let items = feed.items,
            let date = items.first?.pubDate else {
                throw OpenParkingError.decoding(description: "No date or items found", underlyingError: nil)
        }

        let lots = try items.map(parse(item:))
        return DataPoint(dateSource: date, lots: lots)
    }

    func parse(item: RSSFeedItem) throws -> Lot {
        guard let name = item.title?.unescaped,
            let link = item.link,
            let detailURL = URL(string: link),
            let desc = item.description else {
                throw OpenParkingError.decoding(description: "RSS feed item missing title, link or description",
                                            underlyingError: nil)
        }

        guard let metadata = geodata.lot(withName: name) else {
            throw OpenParkingError.missingMetadata(lot: name)
        }

        let freeRegex = Regex("Anzahl.+: (\\d+)")
        guard let freeStr = freeRegex.firstMatch(in: desc)?.captures[0],
            let free = Int(freeStr) else {
                throw OpenParkingError.decoding(description: "Missing free count in item description",
                                                underlyingError: nil)
        }

        var kind: Lot.Kind = .structure
        if name.contains("Parkplatz") {
            kind = .lot
        }

        guard let coordinates = metadata.coordinate else {
            throw OpenParkingError.missingMetadataField("coordinate", lot: name)
        }
        let address = metadata.properties["address"]?.value as? String

        // A few lots have weekday-specific total counts.
        guard var total = metadata.properties["total"]?.value as? Int else {
            throw OpenParkingError.decoding(description: "Missing total count for \(name)", underlyingError: nil)
        }
        if metadata.properties["total_by_weekday"] != nil {
            let weekday = Calendar(identifier: .gregorian).component(.weekday, from: Date())
            if let totalCount = (metadata.properties["total_by_weekday"]?.value as? [String: Int])?[String(weekday)] {
                total = totalCount
            }
        }

        return Lot(name: name,
                   coordinates: coordinates,
                   city: "Basel",
                   region: nil,
                   address: address,
                   free: .discrete(free),
                   total: total,
                   state: .open,
                   kind: kind,
                   detailURL: detailURL)
    }
}
