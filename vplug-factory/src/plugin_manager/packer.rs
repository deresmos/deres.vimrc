use crate::file::FileManager;
use crate::plugin_config::PluginConfig;
use crate::lib::{find_plugin_path, load_file};
use crate::template_creator::TemplateCreator;
use anyhow::Result;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs::File;
use std::io::Write;
use std::path::Path;
use toml;
use log::debug;
use handlebars::{
    to_json, Context, Handlebars, Helper, JsonRender, Output, RenderContext, RenderError,
};
use serde_json::value::{Map};

#[derive(Debug, Default, PartialEq, Serialize, Deserialize)]
pub struct PackerToml {
    plugins: Vec<PackerPlugin>,
}


#[derive(Debug, Default, PartialEq, Clone, Serialize, Deserialize)]
pub struct PackerPlugin {
    repo: String,
    rev: Option<String>,
    tag: Option<String>,
    filetypes: Option<Vec<String>>,
    commands: Option<Vec<String>>,
    maps: Option<Vec<String>>,
    build: Option<String>,
    events: Option<Vec<String>>,
    enable: bool,
    opt: bool,

    setup: Option<String>,
    config: Option<String>,
}

impl PackerPlugin {
    pub fn is_opt(&self) -> bool {
        if self.filetypes.is_some() {
            return true;
        }
        if self.commands.is_some() {
            return true;
        }
        if self.maps.is_some() {
            return true;
        }
        if self.setup.is_some() {
            return true;
        }

        return false;
    }
}

impl PackerPlugin {
    pub fn from_path(path: String) -> Option<Self> {
        let basepath = Path::new(&path);
        let mut plugin = Self::default();

        let yml = PluginConfig::from_yaml(basepath.join("config.yml").to_str().unwrap()).unwrap();
        if !yml.config.enable {
            debug!("Disable plugin: {}", yml.config.url);
            return None;
        }

        match yml.config.url {
            url => {
                if url.starts_with("https://github.com/") {
                    plugin.repo = url.replace("https://github.com/", "");
                } else {
                    plugin.repo = url;
                }
            }
        }

        plugin.rev = yml.config.rev;
        plugin.tag = yml.config.tag;
        plugin.filetypes = yml.config.filetypes;
        plugin.commands = yml.config.commands;
        plugin.maps = yml.config.maps;
        plugin.events = yml.config.events;
        plugin.build = yml.config.r#do;
        plugin.enable = yml.config.enable;
        plugin.opt = yml.config.opt.unwrap_or(false);

        let fm = FileManager::new(&path);
        plugin.setup = fm.load("setup.lua");
        plugin.config = fm.load("start.lua");

        Some(plugin)
    }
}

pub struct PackerMaker {
    plugins_path: String,
}

impl PackerMaker {
    pub fn new(plugins_path: String) -> Self {
        PackerMaker {
            plugins_path: plugins_path,
        }
    }

    pub fn make(&self, output_path: String) -> Result<()> {
        let plugin_paths = find_plugin_path(Path::new(&self.plugins_path))?;

        let plugins: Vec<PackerPlugin> = plugin_paths
            .iter()
            .filter_map(|path| PackerPlugin::from_path(path.into()))
            .collect();
        let mut data = Map::new();
        data.insert("plugins".to_string(), to_json(&plugins));

        let mut handlebars = Handlebars::new();
        handlebars
            .register_template_file("template", "./src/plugin_manager/packer.hbs")
            .unwrap();
        let mut output_file = File::create(output_path)?;
        handlebars.render_to_write("template", &data, &mut output_file)?;
        // let dein_toml = PackerToml::new(&plugins);
        // dein_toml.output_toml(&output_path)?;

        Ok(())
    }
}
