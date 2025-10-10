//
//  MainView.swift
//  PDFHandler
//
//  Created by 上條蓮太朗 on 2025/10/09.
//

import SwiftUI
import PhotosUI

struct MainView: View {
    @State private var pdfViewModel = PDFGeneratorViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                imageThumbnailView()
                errorMessageView()
                imageSelectButton()
                outputPDFButton()
                resetButton()
                shareButton()
                loadingView()
                Spacer()
            }
            .photosPicker(
                isPresented: $pdfViewModel.showPhotoPicker,
                selection: $pdfViewModel.selectedItem,
                matching: .images,
                photoLibrary: .shared()
            )
            .onChange(of: pdfViewModel.selectedItem) { _, newValue in
                pdfViewModel.laodUIImageFromSelectedItem(newValue)
            }
            .padding()
            .navigationTitle("PDF Handler")
        }
    }
}

extension MainView {
    @ViewBuilder
    private func imageThumbnailView() -> some View {
        Group {
            if let uiImage = pdfViewModel.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.1))
                    Text("画像がまだありません")
                        .foregroundStyle(.secondary)
                }
                .frame(height: 200)
            }
        }
        .animation(.default, value: pdfViewModel.uiImage)
    }
    
    @ViewBuilder
    private func errorMessageView() -> some View {
        if let photoLibraryServiceError = pdfViewModel.photoLibraryServiceError {
            Text(photoLibraryServiceError.errorMessage)
                .font(.footnote)
                .foregroundStyle(.red)
        }
    }
    
    private func imageSelectButton() -> some View {
        Button("画像を選択",
               systemImage: "photo.on.rectangle.angled"
        ) {
            pdfViewModel.selectImage()
        }
        .confirmationDialog("画像の選択方法を選んでください",
                            isPresented: $pdfViewModel.showActionSheet,
                            titleVisibility: .visible
        ) {
            Button("フォトライブラリから") {
                pdfViewModel.selectImageFromLibrary()
            }
            Button("サンプル画像から") {
                pdfViewModel.selectImageFromSample()
            }
            Button("キャンセル", role: .cancel) {}
        }
    }
    
    private func outputPDFButton() -> some View {
        Button("PDFにして出力",
               systemImage: "text.document"
        ) {
            pdfViewModel.outputPDF()
        }
        .disabled(pdfViewModel.uiImage == nil)
    }
    
    @ViewBuilder
    private func resetButton() -> some View {
        if pdfViewModel.uiImage != nil {
            Button("リセット",
                   systemImage: "trash"
            ) {
                pdfViewModel.reset()
            }
            .foregroundColor(.red)
        }
    }
    
    @ViewBuilder
    private func shareButton() -> some View {
        if let pdfURL = pdfViewModel.pdfURL {
            ShareLink("共有する", item: pdfURL)
                .padding()
                .onDisappear {
                    /// ディレクトリに残りっぱなしになってしまうので念のため消しておく
                    /// 念のため、というのは、システムが消してくれるところでもあるが、連続で作られたりするとストレージ圧迫されるため
                    try? FileManager.default.removeItem(at: pdfURL)
                }
        }
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        if pdfViewModel.isLoading {
            ProgressView().padding(.top, 4)
        }
    }
}

#Preview {
    MainView()
}
