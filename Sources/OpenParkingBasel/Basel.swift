import Foundation
import OpenParkingBase
import FeedKit
import Regex

public class Basel: Datasource {
    public let name = "Basel"
    public let slug = "basel"
    public let infoUrl = URL(string: "http://www.parkleitsystem-basel.ch/status.php")!
    public let attribution: Attribution? = Attribution(contributor: "Immobilien Basel-Stadt",
                                                       url: URL(string: "http://www.parkleitsystem-basel.ch/impressum.php")!,
                                                       license: "Creative-Commons-Null-Lizenz (CC-0)")

    let feedURL = URL(string: "http://www.parkleitsystem-basel.ch/rss_feed.php")!

    public func data(completion: @escaping (Swift.Result<DataPoint, OpenParkingError>) -> Void) {
        getRSSFeed(url: self.feedURL) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let feed):
                guard let items = feed.items,
                    let date = items.first?.pubDate else {
                        completion(.failure(.decoding(description: "No date or items found", underlyingError: nil)))
                        return
                }
                do {
                    let lots = try items.map(self.parse(item:))
                    let datapoint = DataPoint(dateSource: date, lots: lots)
                    completion(.success(datapoint))
                } catch {
                    if let error = error as? OpenParkingError {
                        completion(.failure(error))
                    } else {
                        completion(.failure(.other(error)))
                    }
                }
            }
        }
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

        var type: Lot.`Type` = .structure
        if name.contains("Parkplatz") {
            type = .lot
        }

        guard let coordinates = metadata.geometry.coord else {
            throw OpenParkingError.decoding(description: "Missing coordinate data for \(name)", underlyingError: nil)
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
                   type: type,
                   detailURL: detailURL)
    }
}
