#import "CQRShims.h"

size_t shim_qrcodegen_BUFFER_LEN_FOR_VERSION(int n) {
	return qrcodegen_BUFFER_LEN_FOR_VERSION(n);
}

// The worst-case number of bytes needed to store one QR Code, up to and including
// version 40. This value equals 3918, which is just under 4 kilobytes.
// Use this more convenient value to avoid calculating tighter memory bounds for buffers.
size_t shim_qrcodegen_BUFFER_LEN_MAX() {
	return qrcodegen_BUFFER_LEN_FOR_VERSION(qrcodegen_VERSION_MAX);
}