import Foundation
import QR

let basename = CommandLine.arguments[0].components(separatedBy: "/").last!
let path: String

if CommandLine.argc < 2 {
    struct StderrOutputStream: TextOutputStream {
        public mutating func write(_ string: String) { fputs(string, stderr) }
    }
    var errStream = StderrOutputStream()
    print("Usage: \(basename) PATH", to: &errStream)
    abort()
} else {
    path = CommandLine.arguments[1]
}

let text = "https://www.holidu.com/goto-appstore?deeplink=https://www.holidu.de/bookings/06ea0342-002f-434b-aa38-d8275ebedffa😎"

let qrCode = try QRCode(text: text)

let png = qrCode.png(pixelSize: 4)

try png.write(to: .init(fileURLWithPath: path))


