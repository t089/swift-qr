//
//  shim.h
//  swift-qr
//
//  Created by Tobias Haeberle on 22.03.19.
//

#ifndef shim_h
#define shim_h

#include "qrcodegen.h"

// Calculates the number of bytes needed to store any QR Code up to and including the given version number,
// as a compile-time constant. For example, 'uint8_t buffer[qrcodegen_BUFFER_LEN_FOR_VERSION(25)];'
// can store any single QR Code from version 1 to 25 (inclusive). The result fits in an int (or int16).
// Requires qrcodegen_VERSION_MIN <= n <= qrcodegen_VERSION_MAX.

size_t shim_qrcodegen_BUFFER_LEN_FOR_VERSION(int n);

// The worst-case number of bytes needed to store one QR Code, up to and including
// version 40. This value equals 3918, which is just under 4 kilobytes.
// Use this more convenient value to avoid calculating tighter memory bounds for buffers.
size_t shim_qrcodegen_BUFFER_LEN_MAX();

#endif /* shim_h */
