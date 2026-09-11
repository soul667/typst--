use wasm_minimal_protocol::*;

initiate_protocol!();

/// Parse MP4/MOV/M4V container to extract video track dimensions.
/// Returns "width,height" as UTF-8 string, e.g. "1920,1080".
///
/// The function parses ISO Base Media File Format (ISO 14496-12) atoms
/// to find moov → trak → tkhd and read the display width/height.
#[wasm_func]
pub fn get_dimensions(data: &[u8]) -> Result<Vec<u8>, String> {
    // Try MP4/MOV/M4V (ISO BMFF)
    if let Some((w, h)) = parse_mp4(data) {
        if w > 0 && h > 0 {
            return Ok(format!("{},{}", w, h).into_bytes());
        }
    }

    // Try AVI (RIFF container)
    if let Some((w, h)) = parse_avi(data) {
        if w > 0 && h > 0 {
            return Ok(format!("{},{}", w, h).into_bytes());
        }
    }

    // Try MKV/WebM (EBML container) - basic support
    if let Some((w, h)) = parse_mkv(data) {
        if w > 0 && h > 0 {
            return Ok(format!("{},{}", w, h).into_bytes());
        }
    }

    Err("unsupported format or dimensions not found".into())
}

// ── MP4/MOV parser ──────────────────────────────────────────────────

/// Read a big-endian u32 from a byte slice.
fn read_u32_be(data: &[u8], offset: usize) -> Option<u32> {
    if offset + 4 > data.len() {
        return None;
    }
    Some(u32::from_be_bytes([
        data[offset],
        data[offset + 1],
        data[offset + 2],
        data[offset + 3],
    ]))
}

/// Read a big-endian u64 from a byte slice.
fn read_u64_be(data: &[u8], offset: usize) -> Option<u64> {
    if offset + 8 > data.len() {
        return None;
    }
    Some(u64::from_be_bytes([
        data[offset],
        data[offset + 1],
        data[offset + 2],
        data[offset + 3],
        data[offset + 4],
        data[offset + 5],
        data[offset + 6],
        data[offset + 7],
    ]))
}

/// Read the 4-byte atom type as a string slice.
fn atom_type(data: &[u8], offset: usize) -> Option<&[u8]> {
    if offset + 4 > data.len() {
        return None;
    }
    Some(&data[offset..offset + 4])
}

/// Iterate over top-level atoms in a byte range.
/// Calls `callback` with (atom_type, atom_data_including_header, atom_data_offset).
fn for_each_atom<F>(data: &[u8], mut callback: F)
where
    F: FnMut(&[u8], &[u8], usize) -> bool, // type, full_atom, offset -> continue?
{
    let mut pos = 0;
    while pos + 8 <= data.len() {
        let size = read_u32_be(data, pos).unwrap_or(0) as u64;
        let atype = match atom_type(data, pos + 4) {
            Some(t) => t,
            None => break,
        };

        let (header_size, atom_size) = if size == 1 {
            // 64-bit extended size
            match read_u64_be(data, pos + 8) {
                Some(s) => (16usize, s),
                None => break,
            }
        } else if size == 0 {
            // Atom extends to end of file
            (8usize, (data.len() - pos) as u64)
        } else {
            (8usize, size)
        };

        if atom_size < header_size as u64 {
            break;
        }

        let end = pos + atom_size as usize;
        if end > data.len() {
            // Truncated atom — try to process what we have
            let atom_data = &data[pos..data.len()];
            callback(atype, atom_data, pos);
            break;
        }

        let atom_data = &data[pos..end];
        if !callback(atype, atom_data, pos) {
            return;
        }

        pos = end;
    }
}

/// Container atoms that hold child atoms (we need to recurse into these).
const CONTAINER_ATOMS: &[&[u8]] = &[b"moov", b"trak", b"mdia", b"minf", b"stbl"];

/// Parse MP4/MOV to find video dimensions from tkhd atom.
fn parse_mp4(data: &[u8]) -> Option<(u32, u32)> {
    let mut result: Option<(u32, u32)> = None;

    find_tkhd(data, &mut result);

    result
}

/// Recursively search for tkhd atoms in an atom hierarchy.
fn find_tkhd(data: &[u8], result: &mut Option<(u32, u32)>) {
    for_each_atom(data, |atype, atom_data, _offset| {
        if atype == b"tkhd" {
            if let Some((w, h)) = parse_tkhd(atom_data) {
                // Only accept video tracks (non-zero dimensions)
                if w > 0 && h > 0 {
                    *result = Some((w, h));
                    return false; // stop searching
                }
            }
        }

        // Recurse into container atoms
        if CONTAINER_ATOMS.iter().any(|c| *c == atype) {
            let header_size = if atom_data.len() >= 16
                && read_u32_be(atom_data, 0) == Some(1)
            {
                16
            } else {
                8
            };
            if header_size < atom_data.len() {
                find_tkhd(&atom_data[header_size..], result);
                if result.is_some() {
                    return false;
                }
            }
        }

        true // continue
    });
}

/// Parse a tkhd (Track Header) atom to extract display width and height.
/// Width and height are stored as fixed-point 16.16 numbers.
fn parse_tkhd(atom_data: &[u8]) -> Option<(u32, u32)> {
    // atom_data includes the 8-byte header (size + type)
    let header_size = if atom_data.len() >= 16
        && read_u32_be(atom_data, 0) == Some(1)
    {
        16 // 64-bit size
    } else {
        8
    };

    if header_size >= atom_data.len() {
        return None;
    }

    let body = &atom_data[header_size..];
    if body.is_empty() {
        return None;
    }

    let version = body[0];

    // Calculate offset to width/height based on version
    let wh_offset = if version == 0 {
        // version(1) + flags(3) + creation(4) + modification(4) + track_id(4)
        // + reserved(4) + duration(4) + reserved(8) + layer(2) + alt_group(2)
        // + volume(2) + reserved(2) + matrix(36) = 76
        76usize
    } else {
        // version(1) + flags(3) + creation(8) + modification(8) + track_id(4)
        // + reserved(4) + duration(8) + reserved(8) + layer(2) + alt_group(2)
        // + volume(2) + reserved(2) + matrix(36) = 88
        88usize
    };

    if wh_offset + 8 > body.len() {
        return None;
    }

    // Fixed-point 16.16: top 16 bits are the integer part
    let width_fp = read_u32_be(body, wh_offset)?;
    let height_fp = read_u32_be(body, wh_offset + 4)?;

    let width = width_fp >> 16;
    let height = height_fp >> 16;

    Some((width, height))
}

// ── AVI parser ──────────────────────────────────────────────────────

/// Parse AVI (RIFF container) to extract video dimensions from the stream header.
fn parse_avi(data: &[u8]) -> Option<(u32, u32)> {
    // AVI starts with "RIFF" + size + "AVI "
    if data.len() < 12 {
        return None;
    }
    if &data[0..4] != b"RIFF" || &data[8..12] != b"AVI " {
        return None;
    }

    // Search for 'strf' chunk which contains BITMAPINFOHEADER
    // BITMAPINFOHEADER: size(4) + width(4, LE) + height(4, LE, signed)
    let strf = b"strf";
    for i in 0..data.len().saturating_sub(8) {
        if &data[i..i + 4] == strf {
            let chunk_start = i + 8; // skip "strf" + chunk_size
            if chunk_start + 12 > data.len() {
                continue;
            }
            // BITMAPINFOHEADER: biSize(4), biWidth(4), biHeight(4)
            let w = u32::from_le_bytes([
                data[chunk_start + 4],
                data[chunk_start + 5],
                data[chunk_start + 6],
                data[chunk_start + 7],
            ]);
            let h_raw = i32::from_le_bytes([
                data[chunk_start + 8],
                data[chunk_start + 9],
                data[chunk_start + 10],
                data[chunk_start + 11],
            ]);
            let h = h_raw.unsigned_abs();
            if w > 0 && h > 0 && w < 100000 && h < 100000 {
                return Some((w, h));
            }
        }
    }

    None
}

// ── MKV/WebM parser (basic) ─────────────────────────────────────────

/// Read an EBML variable-length integer (vint). Returns (value, bytes_consumed).
fn read_vint(data: &[u8], pos: usize) -> Option<(u64, usize)> {
    if pos >= data.len() {
        return None;
    }
    let first = data[pos];
    if first == 0 {
        return None;
    }

    let len = first.leading_zeros() as usize + 1;
    if len > 8 || pos + len > data.len() {
        return None;
    }

    let mut val = (first as u64) & ((1u64 << (8 - len)) - 1);
    for i in 1..len {
        val = (val << 8) | data[pos + i] as u64;
    }

    Some((val, len))
}

/// Read an EBML unsigned integer of `size` bytes at `pos`.
fn read_ebml_uint(data: &[u8], pos: usize, size: usize) -> Option<u64> {
    if pos + size > data.len() || size > 8 {
        return None;
    }
    let mut val = 0u64;
    for i in 0..size {
        val = (val << 8) | data[pos + i] as u64;
    }
    Some(val)
}

// MKV Element IDs
const SEGMENT: u32 = 0x18538067;
const TRACKS: u32 = 0x1654AE6B;
const TRACK_ENTRY: u32 = 0xAE;
const VIDEO: u32 = 0xE0;
const PIXEL_WIDTH: u32 = 0xB0;
const PIXEL_HEIGHT: u32 = 0xBA;

/// Read an EBML element ID at `pos`. Returns (id, bytes_consumed).
fn read_element_id(data: &[u8], pos: usize) -> Option<(u32, usize)> {
    if pos >= data.len() {
        return None;
    }
    let first = data[pos];
    let len = first.leading_zeros() as usize + 1;
    if len > 4 || pos + len > data.len() {
        return None;
    }
    let mut id = 0u32;
    for i in 0..len {
        id = (id << 8) | data[pos + i] as u32;
    }
    Some((id, len))
}

/// Parse MKV/WebM (EBML) to extract video dimensions.
fn parse_mkv(data: &[u8]) -> Option<(u32, u32)> {
    if data.len() < 4 {
        return None;
    }

    // Check for EBML header (element ID 0x1A45DFA3)
    if data.len() < 4 || read_u32_be(data, 0)? != 0x1A45DFA3 {
        return None;
    }

    // Skip EBML header element
    let (_, id_len) = read_element_id(data, 0)?;
    let (header_size, size_len) = read_vint(data, id_len)?;
    let mut pos = id_len + size_len + header_size as usize;

    // Now we should be at the Segment element
    let search_limit = data.len().min(64 * 1024 * 1024); // search first 64MB max
    while pos < search_limit {
        let (eid, eid_len) = read_element_id(data, pos)?;
        let (esize, esize_len) = read_vint(data, pos + eid_len)?;
        let content_pos = pos + eid_len + esize_len;

        if eid == SEGMENT {
            // Recurse into Segment to find Tracks
            return find_video_dims_in_mkv(data, content_pos, search_limit);
        }

        pos = content_pos + esize as usize;
    }

    None
}

fn find_video_dims_in_mkv(data: &[u8], start: usize, limit: usize) -> Option<(u32, u32)> {
    let mut pos = start;
    while pos < limit && pos < data.len() {
        let (eid, eid_len) = read_element_id(data, pos)?;
        let (esize, esize_len) = read_vint(data, pos + eid_len)?;
        let content_pos = pos + eid_len + esize_len;
        let content_end = content_pos + esize as usize;

        match eid {
            TRACKS => {
                return find_track_video_dims(data, content_pos, content_end.min(limit));
            }
            _ => {
                // Skip unknown/irrelevant elements
                // For master elements with unknown size, we can't skip properly
                if esize == 0x00FFFFFFFFFFFFFF {
                    // Unknown size — try to recurse
                    return find_video_dims_in_mkv(data, content_pos, limit);
                }
                pos = content_end;
            }
        }
    }
    None
}

fn find_track_video_dims(data: &[u8], start: usize, limit: usize) -> Option<(u32, u32)> {
    let mut pos = start;
    while pos < limit && pos < data.len() {
        let (eid, eid_len) = read_element_id(data, pos)?;
        let (esize, esize_len) = read_vint(data, pos + eid_len)?;
        let content_pos = pos + eid_len + esize_len;
        let content_end = content_pos + esize as usize;

        if eid == TRACK_ENTRY {
            if let Some(dims) = parse_track_entry(data, content_pos, content_end.min(limit)) {
                return Some(dims);
            }
        }

        pos = content_end;
    }
    None
}

fn parse_track_entry(data: &[u8], start: usize, limit: usize) -> Option<(u32, u32)> {
    let mut pos = start;
    while pos < limit && pos < data.len() {
        let (eid, eid_len) = read_element_id(data, pos)?;
        let (esize, esize_len) = read_vint(data, pos + eid_len)?;
        let content_pos = pos + eid_len + esize_len;
        let content_end = content_pos + esize as usize;

        if eid == VIDEO {
            return parse_video_element(data, content_pos, content_end.min(limit));
        }

        pos = content_end;
    }
    None
}

fn parse_video_element(data: &[u8], start: usize, limit: usize) -> Option<(u32, u32)> {
    let mut width: Option<u32> = None;
    let mut height: Option<u32> = None;
    let mut pos = start;

    while pos < limit && pos < data.len() {
        let (eid, eid_len) = read_element_id(data, pos)?;
        let (esize, esize_len) = read_vint(data, pos + eid_len)?;
        let content_pos = pos + eid_len + esize_len;
        let content_end = content_pos + esize as usize;

        match eid {
            PIXEL_WIDTH => {
                width = read_ebml_uint(data, content_pos, esize as usize).map(|v| v as u32);
            }
            PIXEL_HEIGHT => {
                height = read_ebml_uint(data, content_pos, esize as usize).map(|v| v as u32);
            }
            _ => {}
        }

        if let (Some(w), Some(h)) = (width, height) {
            return Some((w, h));
        }

        pos = content_end;
    }

    match (width, height) {
        (Some(w), Some(h)) => Some((w, h)),
        _ => None,
    }
}
