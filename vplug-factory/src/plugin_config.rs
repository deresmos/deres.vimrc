use crate::lib::load_file;
use anyhow::Result;
use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::Write;

#[derive(Debug, Default, PartialEq, Serialize, Deserialize)]
pub struct PluginConfig {
    pub config: Config,
}

#[derive(Debug, Default, PartialEq, Serialize, Deserialize)]
pub struct Config {
    pub url: String,
    pub rev: Option<String>,
    pub tag: Option<String>,
    pub filetypes: Option<Vec<String>>,
    pub commands: Option<Vec<String>>,
    pub maps: Option<Vec<String>>,
    pub events: Option<Vec<String>>,
    pub r#do: Option<String>,
    pub enable: bool,
    pub opt: Option<bool>,
}

#[derive(Debug, Default, PartialEq, Serialize, Deserialize)]
pub struct DeinConfig {
    pub ftplugin: bool,
    pub on_lua: Option<Vec<String>>,
    pub on_event: Option<Vec<String>>,
    pub on_source: Option<Vec<String>>,
}

impl PluginConfig {
    pub fn from_yaml(file: &str) -> Result<Self> {
        let contents = load_file(file)?;
        let config: Self = serde_yaml::from_str(&contents)?;

        Ok(config)
    }

    pub fn output_yaml(&self, filepath: &str) -> Result<()> {
        let s = serde_yaml::to_string(self)?;

        let mut file = File::create(filepath)?;
        file.write_all(s.as_bytes())?;

        Ok(())
    }

    pub fn set_enable(&mut self, is_enable: bool) {
        self.config.enable = is_enable;
    }
}
