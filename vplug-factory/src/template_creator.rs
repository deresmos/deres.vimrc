use crate::file::FileManager;
use crate::plugin_config::PluginConfig;
use anyhow::Result;
use std::fs;
use std::io::{Error, ErrorKind};
use std::path::Path;

pub struct TemplateCreator {
    basepath: String,
}

impl TemplateCreator {
    pub fn new(basepath: String) -> Self {
        TemplateCreator { basepath: basepath }
    }

    pub fn create(&self, name: &str, tag: &str) -> Result<()> {
        let mut config_yaml = PluginConfig::default();
        config_yaml.set_enable(true);

        let dirpath = Path::new(&self.basepath).join(tag).join(name);
        let dirpath2 = Path::new(&dirpath);
        if dirpath2.exists() {
            return Err(Error::new(
                ErrorKind::Other,
                format!("already exists template: {}", dirpath.to_str().unwrap()),
            )
            .into());
        }

        fs::create_dir_all(&dirpath)?;

        // create config.yml
        let config_path = dirpath.join("config.yml");
        config_yaml.output_yaml(&config_path.to_str().unwrap())?;

        let empty = b"";

        // create add.vim
        let fm = FileManager::new(dirpath.to_str().unwrap());
        fm.write("add.vim", empty)?;
        fm.write("preload.vim", empty)?;
        fm.write("postload.vim", empty)?;

        println!("created {}", dirpath.to_str().unwrap());

        Ok(())
    }
}
