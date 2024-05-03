use anyhow::*;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() -> Result<()> {
    let mut fh: Result<File, Error> = File::open("foo.txt");
    let actual_file: File = fh.unwrap();
    let lines = BufReader::new(fh).lines().flatten();

    for line in lines {
        println!("{line}");
    }

    Ok(())
}
