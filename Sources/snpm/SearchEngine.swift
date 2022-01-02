//
//  SearchEngine.swift
//  snpm
//
//  Created by Gleb Zavyalov on 02.01.2022.
//

import Foundation
import Files

// https://www.icloud.com/notes/049665pYgBg82TeJVNvQ6A2CA#snippet_manager

struct EngineResult {
    let name: String
    let directory: String
    let contains: String
}


class SnippetSearchEngine {

    public static func distance(aStr: String, bStr: String) -> Int {
        // create character arrays
        let a = Array(aStr)
        let b = Array(bStr)

        // initialize matrix of size |a|+1 * |b|+1 to zero
        var dist = [[Int]]()
        for _ in 0...a.count {
            dist.append(Array(repeating: 0, count: b.count + 1))
    //        dist.append([Int](count: b.count + 1, repeatedValue: 0))
        }

        // 'a' prefixes can be transformed into empty string by deleting every char
        for i in 1...a.count {
            dist[i][0] = i
        }

        // 'b' prefixes can be created from empty string by inserting every char
        for j in 1...b.count {
            dist[0][j] = j
        }

        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i][j] = dist[i-1][j-1]  // noop
                } else {
                    dist[i][j] = min(
                        dist[i-1][j] + 1,  // deletion
                        dist[i][j-1] + 1,  // insertion
                        dist[i-1][j-1] + 1  // substitution
                    )
                }
            }
        }

        return dist[a.count][b.count]
    }

}
