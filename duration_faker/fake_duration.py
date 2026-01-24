import struct, sys


def modify_mvhd(data: bytearray, new_mvhd32: int = 0x7FFFFFFF, new_mvhd64: int = 0x7FFFFFFFFFFFFFFF) -> bytearray:
    mvhd_pos = data.find(b'mvhd')
    if mvhd_pos == -1: raise Exception("mvhd not found.")

    version = data[mvhd_pos + 4]
    if version == 0:  # 32-bit
        struct.pack_into('>I', data, mvhd_pos + 20, new_mvhd32)
    else:  # 64-bit
        struct.pack_into('>Q', data, mvhd_pos + 28, new_mvhd64)
    return data


def modify_timescale(data: bytearray, new_timescale32: int = 1, new_timescale64: int = 1) -> bytearray:
    mvhd_pos = data.find(b'mvhd')
    if mvhd_pos == -1: raise Exception("mvhd not found.")
    
    version = data[mvhd_pos + 4]
    if version == 0:  # 32-bit
        struct.pack_into('>I', data, mvhd_pos + 16, new_timescale32)
    else:  # 64-bit
        struct.pack_into('>I', data, mvhd_pos + 20, new_timescale64)
    return data


def modify_tkhd(data: bytearray, new_tkhd32: int = 0x7FFFFFFF, new_tkhd64: int = 0x7FFFFFFFFFFFFFFF) -> bytearray:
    tkhd_pos = data.find(b'tkhd')
    if tkhd_pos == -1: raise Exception("tkhd not found.")
    
    version = data[tkhd_pos + 8]
    if version == 0:  # 32-bit
        struct.pack_into('>I', data, tkhd_pos + 24, new_tkhd32)
    else:  # 64-bit
        struct.pack_into('>Q', data, tkhd_pos + 32, new_tkhd64)
    return data



data = None

with open(sys.argv[1], 'rb') as file_in:
    data = bytearray(file_in.read())
#### pipeline ####

data = modify_timescale(data)
data = modify_tkhd(data, 29700000, 29700000)
data = modify_mvhd(data, 29700000, 29700000)

####          ####
with open(sys.argv[2], 'wb') as file_out:
    file_out.write(data)
