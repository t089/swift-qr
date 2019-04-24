import CQR
import CQRShims

private let MAX_BUFFER_LEN = shim_qrcodegen_BUFFER_LEN_MAX()

public struct QRCode {
    public enum Error: Swift.Error {
        case inputTooLarge
    }
    
    public enum ECCLevel: UInt32 {
        case low = 0, medium, quartile, high
    }
    
    public let text: String
    public let size: Int
    private let qr: [UInt8]
    
    public init(text: String, eccLevel: ECCLevel = .medium) throws {
        var buffer = [UInt8](repeating: 0, count: MAX_BUFFER_LEN)
        var qr0 = [UInt8](repeating: 0, count: MAX_BUFFER_LEN)
        
        let utf8 = text.utf8CString
        
        guard utf8.count <= MAX_BUFFER_LEN else {
            throw Error.inputTooLarge
        }
        
        try utf8.withUnsafeBufferPointer { (ptr) in
            guard qrcodegen_encodeText(ptr.baseAddress, &buffer, &qr0, qrcodegen_Ecc(rawValue: eccLevel.rawValue), Int32(qrcodegen_VERSION_MIN), Int32(qrcodegen_VERSION_MAX), qrcodegen_Mask_AUTO, false) else {
                throw Error.inputTooLarge
            }
        }
        
        
        self.size = Int(qrcodegen_getSize(&qr0))
        self.qr = qr0
        self.text = text
    }
    
    public subscript(x: Int, y: Int) -> Bool {
        precondition(x < self.size)
        precondition(y < self.size)
        return qrcodegen_getModule(self.qr, Int32(x), Int32(y))
    }
}
