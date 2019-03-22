//
//  QRCodePNG.swift
//  CQR
//
//  Created by Tobias Haeberle on 22.03.19.
//

import Foundation
import clibpng

public extension QRCode {
    public func png(pixelSize: Int) -> Data {
        var png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, nil, nil, nil);
        var info_ptr = png_create_info_struct(png_ptr)
        defer {
            png_destroy_write_struct(&png_ptr, &info_ptr)
        }
        
        struct State {
            var data: Data = Data()
        }
        
        func write(png_ptr: png_structp!, data: png_bytep!, length: png_size_t) {
            let statePtr = png_get_io_ptr(png_ptr)!.bindMemory(to: State.self, capacity: 1)
            statePtr.pointee.data.append(data, count: length)
        }
        
        func flush(png_ptr: png_structp!) {
            
        }
        
        var state = State()
        
        png_set_write_fn(png_ptr, &state, write, flush)
        
        let height = self.size * pixelSize
        let width = self.size * pixelSize
        
        png_set_IHDR(png_ptr, info_ptr, png_uint_32(width), png_uint_32(height), 8, PNG_COLOR_TYPE_GRAY, PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_BASE)
        
        let rows : png_bytepp! = png_bytepp.allocate(capacity: Int(height))
        
        for i in 0..<height {
            rows[i] = png_bytep.allocate(capacity: width)
            for k in 0..<width {
                rows[i]![k] = self[k / pixelSize, i / pixelSize] ? 0x00 : 0xFF
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
