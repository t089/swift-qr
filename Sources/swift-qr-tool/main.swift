import Foundation
import QR

let basename = CommandLine.arguments[0].components(separatedBy: "/").last!
let path: String
let text: String
var pixelSize = 4
var border = pixelSize

func fail() -> Never {
    struct StderrOutputStream: TextOutputStream {
        public mutating func write(_ string: String) { fputs(string, stderr) }
    }
    var errStream = StderrOutputStream()
    print("Usage: \(basename) CONTENT PATH [PIXEL_SIZE]", to: &errStream)
    abort()
}

if CommandLine.argc < 3 {
    fail()
} else {
    text = CommandLine.arguments[1]
    path = CommandLine.arguments[2]
    if CommandLine.arguments.count > 3 {
        guard let size = Int(CommandLine.arguments[3]) else {
            fail()
        }

        pixelSize = size
    }
}

let qrCode = try QRCode(text: text)

let png : [UInt8] = qrCode.png(pixelSize: pixelSize, border: border)

try Data(png).write(to: .init(fileURLWithPath: path))


