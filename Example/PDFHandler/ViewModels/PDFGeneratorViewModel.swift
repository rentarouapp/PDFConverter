//
//  PDFGeneratorViewModel.swift
//  PDFHandler
//
//  Created by 上條蓮太朗 on 2025/10/09.
//

import SwiftUI
import Observation
import PhotosUI

@Observable
final class PDFGeneratorViewModel {
    var selectedItem: PhotosPickerItem?
    var uiImage: UIImage?
    var isLoading = false
    var pdfURL: URL?
    var showActionSheet = false
    var showPhotoPicker = false
    var photoLibraryServiceError: PhotoLibraryServiceError?
}

@MainActor
extension PDFGeneratorViewModel {
    /// 画像を選択するボタン
    func selectImage() {
        showActionSheet = true
    }
    
    /// ライブラリから画像を選ぶ選択肢タップ
    func selectImageFromLibrary() {
        showPhotoPicker = true
    }
    
    /// サンプル画像を選ぶ選択肢タップ
    func selectImageFromSample() {
        //uiImage = ResourceUtil.selectSampleImage()
    }
    
    /// PDFを出力
    func outputPDF() {
        guard let uiImage else { return }
        let _ = FileManager.default.temporaryDirectory
            .appendingPathComponent("sample.pdf")
        //pdfURL = PDFService.makePDFURL(from: [uiImage])
    }
    
    /// リセット
    func reset() {
        photoLibraryServiceError = nil
        uiImage = nil
        pdfURL = nil
    }
}

@MainActor
extension PDFGeneratorViewModel {
    /// PhotosPickerから選択された要素からUIImageを抽出する
    func laodUIImageFromSelectedItem(_ item: PhotosPickerItem?) {
        photoLibraryServiceError = nil
        guard let item else { return }
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                let image = try await PhotoLibraryService.image(from: item)
                uiImage = image
            } catch {
                if let _photoLibraryServiceError = error as? PhotoLibraryServiceError {
                    photoLibraryServiceError = _photoLibraryServiceError
                } else {
                    photoLibraryServiceError = .unexpected
                }
            }
        }
    }
}
