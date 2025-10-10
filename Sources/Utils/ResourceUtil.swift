//
//  ResourceUtil.swift
//  PDFHandlerPackage
//
//  Created by 上條蓮太朗 on 2025/10/10.
//

import UIKit

public struct ResourceUtil {
    // サンプル画像をUIImageで返す
    public static func selectSampleImage() -> UIImage? {
        if let url = Bundle.module.url(forResource: "resume_sample", withExtension: "png"),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
}
