//extern crate cbindgen;

use std::env;

fn main() {
    let crate_dir = env::var("CARGO_MANIFEST_DIR").unwrap();
    println!("crate_dir {}",crate_dir);
    
    //let mut config: cbindgen::Config = Default::default();
    //config.language = cbindgen::Language::C;
    //cbindgen::generate_with_config(&crate_dir, config)
    //  .unwrap()
    //  .write_to_file("target/test_rust_lib.h");
}