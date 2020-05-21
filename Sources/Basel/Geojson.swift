// This is a workaround until Swift packages properly support resources.

import Datasource
import Foundation

let geodata = try! JSONDecoder().decode(GeoJson.self, from: geojson.data(using: .utf8)!)
let geojson = """
{
  "type": "FeatureCollection",
  "features": [{
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.6089067, 47.5651794]
    },
    "properties": {
      "name": "Parkhaus Bad. Bahnhof",
      "address": "Schwarzwaldstrasse 160",
      "total": 300,
      "total_by_weekday": {
        "7": 750,
        "1": 750
      }
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.602175, 47.563241]
    },
    "properties": {
      "name": "Parkhaus Messe",
      "address": "Riehenstrasse 101",
      "total": 752
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.5967098, 47.5630411]
    },
    "properties": {
      "name": "Parkhaus Europe",
      "address": "Hammerstrasse 68",
      "total": 120
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.594263, 47.5607142]
    },
    "properties": {
      "name": "Parkhaus Rebgasse",
      "address": "Rebgasse 20",
      "total": 250
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.5946604, 47.5639644]
    },
    "properties": {
      "name": "Parkhaus Claramatte",
      "address": "Klingentalstrasse 25",
      "total": 100,
      "total_by_weekday": {
        "7": 170,
        "1": 170
      }
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.5917937, 47.5622725]
    },
    "properties": {
      "name": "Parkhaus Clarahuus",
      "address": "Webergasse 34",
      "total": 52
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.5874932, 47.5506254]
    },
    "properties": {
      "name": "Parkhaus Elisabethen",
      "address": "Steinentorberg 5",
      "total": 840
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.5858936, 47.5524554]
    },
    "properties": {
      "name": "Parkhaus Steinen",
      "address": "Steinenschanze 5",
      "total": 526
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.5824076, 47.561101]
    },
    "properties": {
      "name": "Parkhaus City-USB",
      "address": "Schanzenstrasse 48",
      "total": 1114
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.58658, 47.5592347]
    },
    "properties": {
      "name": "Parkhaus Storchen",
      "address": "Fischmarkt 10",
      "total": 142
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.5929374, 47.5468617]
    },
    "properties": {
      "name": "Parkhaus Post Basel",
      "address": "Gartenstrasse 143",
      "total": 72
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.5922975, 47.547299]
    },
    "properties": {
      "name": "Parkhaus Centralbahnparking",
      "address": "Gartenstrasse 150",
      "total": 286
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.5943046, 47.5504299]
    },
    "properties": {
      "name": "Parkhaus Aeschen",
      "address": "Aeschengraben 9",
      "total": 97
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.593512, 47.5515968]
    },
    "properties": {
      "name": "Parkhaus Anfos",
      "address": "Henric Petri-Strasse 21",
      "total": 162
    }
  }, {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [7.5884556, 47.5458851]
    },
    "properties": {
      "name": "Parkhaus Bahnhof Süd",
      "address": "Güterstrasse 115",
      "total": 100
    }
  }]
}
"""
