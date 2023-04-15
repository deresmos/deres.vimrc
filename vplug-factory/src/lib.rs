use anyhow::{Context, Result};
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

pub fn load_file(file: &str) -> Result<String> {
    let mut file = File::open(file).with_context(|| format!("failed to open file: {}", file))?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)
        .expect("Unable to read file");

    Ok(contents)
}

pub fn find_plugin_path(path: &Path) -> Result<Vec<String>> {
    let mut dir_paths: Vec<String> = Vec::new();
    for entry in path.read_dir().expect("read_dir call failed") {
        if let Ok(entry) = entry {
            let dirname = path.join(&entry.file_name());

            if dirname.is_dir() {
                dir_paths.append(&mut find_plugin_path(&dirname)?);
            } else if dirname.ends_with("config.yml") {
                dir_paths.push(dirname.parent().unwrap().to_str().unwrap().into());
            }
        };
    }

    dir_paths.sort();
    Ok(dir_paths)
}
