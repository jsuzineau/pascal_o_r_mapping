//Note: to generate a header file from this: https://github.com/eqrion/cbindgen

#[no_mangle]
pub extern "C" fn Hello_from_rust() { println!("Hello from Rust!"); }

#[no_mangle]
pub extern "C" fn Test_PChar( _s: *const libc::c_char)-> *const libc::c_char { _s }

#[no_mangle]
pub extern "C" fn Test_double( _d: f64)-> f64 { _d }

#[no_mangle]
pub extern "C" fn Add(left: usize, right: usize) -> usize {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = Add(2, 2);
        assert_eq!(result, 4);
    }
}
