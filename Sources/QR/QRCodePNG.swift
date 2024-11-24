//
//  QRCodePNG.swift
//  CQR
//
//  Created by Tobias Haeberle on 22.03.19.
//

import clibpng

extension QRCode {
    public func png(pixelSize: Int, border: Int = 0) -> [UInt8] {
        var png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, nil, nil, nil);
        var info_ptr = png_create_info_struct(png_ptr)
        defer {
            png_destroy_write_struct(&png_ptr, &info_ptr)
        }
        
        class State {
            var data: [UInt8] = []
        }
        
        func write(png_ptr: png_structp!, data: png_bytep!, length: png_size_t) {
            let state : State = Unmanaged<State>.fromOpaque(png_get_io_ptr(png_ptr)).takeUnretainedValue()
            let buffer = UnsafeBufferPointer(start: data, count: length)
            state.data.append(contentsOf: buffer)
        }
        
        func flush(png_ptr: png_structp!) {
            
        }
        
        let state = State()

        let statePointer = Unmanaged.passUnretained(state)
        
        png_set_write_fn(png_ptr, statePointer.toOpaque(), write, flush)
        
        let borderWidth = pixelSize * border
        let height = self.size * pixelSize + 2 * borderWidth
        let width = self.size * pixelSize + 2 * borderWidth
        
        png_set_IHDR(png_ptr, info_ptr, png_uint_32(width), png_uint_32(height), 8, PNG_COLOR_TYPE_GRAY, PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_BASE)
        
        let rows : png_bytepp! = png_bytepp.allocate(capacity: Int(height))
        
        for i in 0..<height {
            rows[i] = png_bytep.allocate(capacity: width)
            for k in 0..<width {
                if i < borderWidth || i >= height - borderWidth || k < borderWidth || k >= width - borderWidth {
                    rows[i]![k] = 0xFF
                } else {
                    rows[i]![k] = self[(k-borderWidth) / pixelSize, (i-borderWidth) / pixelSize] ? 0x00 : 0xFF
                }
            }
        }
        
        png_set_rows(png_ptr, info_ptr, rows)
        png_write_png(png_ptr, info_ptr, 0, nil)
        
        for i in 0..<height {
            rows[i]?.deallocate()
        }
        rows.deallocate()
        
        return state.data
    }
}
