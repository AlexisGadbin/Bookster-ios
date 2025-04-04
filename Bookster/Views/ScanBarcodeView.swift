//
//  ScanBarcodeView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 29/03/2025.
//

import CodeScanner
import SwiftUI

struct ScanBarcodeView: View {
    var onScanCompleted: ((String) -> Void)?
    
    init(onScanCompleted: ((String) -> Void)? = nil) {
        self.onScanCompleted = onScanCompleted
    }
    
    var body: some View {
        CodeScannerView(
            codeTypes: [.ean13], simulatedData: "9782253174073",
            completion: handleScan)
    }
    
    @MainActor
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let isbnCode = result.string
            
            if let onScanCompleted = self.onScanCompleted {
                onScanCompleted(isbnCode)
            }
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}
