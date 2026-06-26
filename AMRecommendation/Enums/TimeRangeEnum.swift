//
//  TimeRangeEnum.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 25/06/26.
//

import Foundation

// Over what time frame the affinities are computed.
// Valid values: long_term (calculated from ~1 year of data and including all new data as it becomes available),
// medium_term (approximately last 6 months),
// short_term (approximately last 4 weeks). Default: medium_term
public enum TimeRangeEnum: String {
    case shortTerm = "short_term"   // ~4 weeks
    case mediumTerm = "medium_term" // ~6 months
    case longTerm = "long_term"     // ~1 year
}
