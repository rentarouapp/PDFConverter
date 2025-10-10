//
//  PhotoLibraryService.swift
//  PDFHandler
//
//  Created by 上條蓮太朗 on 2025/10/10.
//

import UIKit
import SwiftUI
import PhotosUI

enum PhotoLibraryServiceError: Error {
    case failedToLoad
    case invalidImageData
    case unexpected
    
    var errorMessage: String {
        switch self {
        case .failedToLoad:
            return "Failed to load photos."
        case .invalidImageData:
            return "Invalid image data."
        case .unexpected:
            return "Unexpected error."
        }
    }
}

struct PickedUIImage: Transferable {
    let image: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw PhotoLibraryServiceError.invalidImageData
            }
            return PickedUIImage(image: uiImage)
        }
    }
}

struct PhotoLibraryService {
    /// Convert a PhotosPickerItem into UIImage using Swift Concurrency.
    /// Tries Data first for broad compatibility, then falls back to UIImage.
    static func image(from item: PhotosPickerItem) async throws -> UIImage {
        // Prefer loading as Data to preserve original bytes when possible
        if let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            return image
        }
        // Fallback: load via a Transferable wrapper for UIImage
        if let picked = try? await item.loadTransferable(type: PickedUIImage.self) {
            return picked.image
        }
        throw PhotoLibraryServiceError.failedToLoad
    }
}
