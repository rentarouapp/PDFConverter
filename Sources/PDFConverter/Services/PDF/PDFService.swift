//
//  PDFService.swift
//  PDFHandlerPackage
//
//  Created by 上條蓮太朗 on 2025/10/10.
//

import PDFKit
import UIKit

public final class PDFService {

    /// UIImage配列から編集不可PDFのDataを返す
    /// - Parameters:
    ///   - images: PDFにするUIImage配列
    ///   - author: PDFの作者名（オプション）
    ///   - ownerPassword: 編集不可にするパスワード（オプション）
    /// - Returns: PDFデータ（Data）
    public static func makePDFData(
        from images: [UIImage],
        author: String? = nil,
        ownerPassword: String? = nil
    ) -> Data? {
        let pdfDocument = PDFDocument()

        // ページ追加
        for (index, image) in images.enumerated() {
            if let page = PDFPage(image: image) {
                pdfDocument.insert(page, at: index)
            }
        }

        // メタデータ設定
        pdfDocument.documentAttributes = [
            PDFDocumentAttribute.titleAttribute: "Generated PDF",
            PDFDocumentAttribute.authorAttribute: author ?? "PDFService",
            PDFDocumentAttribute.creatorAttribute: "YourApp"
        ]

        // 編集不可にする ownerPassword 設定
        let ownerPwd = ownerPassword ?? UUID().uuidString
        let options: [PDFDocumentWriteOption: Any] = [
            .ownerPasswordOption: ownerPwd,
            .userPasswordOption: "" // 閲覧可能
        ]

        // 一時的にURLに書き出してからData取得
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".pdf")

        guard pdfDocument.write(to: tempURL, withOptions: options) else { return nil }
        return try? Data(contentsOf: tempURL)
    }

    /// UIImage配列から編集不可PDFを一時フォルダに書き出してURLを返す
    /// - Parameters:
    ///   - images: PDFにするUIImage配列
    ///   - author: PDFの作者名（オプション）
    ///   - ownerPassword: 編集不可にするパスワード（オプション）
    /// - Returns: PDFの一時ファイルURL
    public static func makePDFURL(
        from images: [UIImage],
        author: String? = nil,
        ownerPassword: String? = nil
    ) -> URL? {
        guard let pdfData = makePDFData(from: images, author: author, ownerPassword: ownerPassword) else {
            return nil
        }

        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".pdf")

        do {
            try pdfData.write(to: tempURL)
            return tempURL
        } catch {
            print("PDF保存失敗: \(error)")
            return nil
        }
    }
}
