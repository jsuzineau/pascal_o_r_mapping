use std::ffi::{CStr, CString};
use std::os::raw::c_char;

use html_cleaning::{CleaningOptions, Document, HtmlCleaner};

fn clean_html_internal(input: &str) -> Result<String, String> {
    let options = CleaningOptions::builder()
        .remove_tags(&["script", "style", "noscript", "iframe", "form"])
        .build();

    let cleaner = HtmlCleaner::with_options(options);
    let doc = Document::from(input);

    cleaner.clean(&doc);

    Ok(doc.html().to_string())
}

#[unsafe(no_mangle)]
pub extern "C" fn html_clean(_s: *const c_char) -> *const c_char {
    if _s.is_null() {
        return std::ptr::null();
    }

    let input = unsafe { CStr::from_ptr(_s) };

    let input_str = match input.to_str() {
        Ok(s) => s,
        Err(_) => return std::ptr::null(),
    };

    let cleaned = match clean_html_internal(input_str) {
        Ok(s) => s,
        Err(_) => return std::ptr::null(),
    };

    match CString::new(cleaned) {
        Ok(cstr) => cstr.into_raw(),
        Err(_) => std::ptr::null(),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn html_clean_free(ptr: *mut c_char) {
    if ptr.is_null() {
        return;
    }

    unsafe {
        let _ = CString::from_raw(ptr);
    }
}
