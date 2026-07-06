//
//  AlbumGroupEnum.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

/* A comma-separated list of keywords that will be used to filter the response. If not supplied, all album types will be returned.
Valid values are:
- album
- single
- appears_on
- compilation
For example: include_groups=album,single.
 */
public enum AlbumGroupEnum: String, CaseIterable {
    case album = "album"
    case single = "single"
    case appearsOn = "appears_on"
    case compilation = "compilation"
}

// Since the API expects a string like "album,single", this function converts the array of AlbumGroupEnum values into a comma separated string.
extension Array where Element == AlbumGroupEnum {
    func asAPIQueryString() -> String {
        return self.map { $0.rawValue }.joined(separator: ",")
    }
}
