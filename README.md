# PDF Converter 📄

## Overview

A library for iOS apps that converts UIImage to PDF with optional features.

Everything is made with Swift.

Supports `iOS17` and later.

## Usage

You can use this library using the Swift Package Manager.

Import the library in the source code:
```
import PDFConverter
```
Pass an array of UIImage objects to output the file paths of saved PDFs.
```
let uiImage: UIImage = ...
let pdfPathURL: URL? = PDFService.makePDFURL(from: [uiImage])
```

## Example

Open the following `.xcodeproj` file and build it to immediately test the behavior in the sample app.
```
PDFConverter/Example/PDFHandler.xcodeproj
```
