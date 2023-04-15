use crate::lib::load_file;
use anyhow::Result;
use std::fs::File;
use std::io::Write;
use std::path::Path;

pub struct FileManager {
    basepath: String,
}

impl FileManager {
    pub fn new(basepath: &str) -> Self {
        FileManager {
            basepath: basepath.into(),
        }
    }

    pub fn load(&self, filepath: &str) -> Option<String> {
        let basepath = Path::new(self.basepath.as_str());
        let contents = load_file(basepath.join(filepath).to_str().unwrap()).unwrap();
        if contents.is_empty() {
            return None;
        }

        Some(contents)
    }

    pub fn write(&self, filepath: &str, contents: &[u8]) -> Result<()> {
        let basepath = Path::new(self.basepath.as_str());
        let path = basepath.join(filepath);
        let mut file = File::create(path.to_str().unwrap())?;
        file.write_all(contents)?;

        Ok(())
    }
}
