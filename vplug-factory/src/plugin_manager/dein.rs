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

#[derive(Debug, Default, PartialEq, Serialize, Deserialize)]
pub struct DeinToml {
    plugins: Vec<DeinPlugin>,
}

impl DeinToml {
    pub fn new(plugins: &Vec<DeinPlugin>) -> Self {
        DeinToml {
            plugins: plugins.clone(),
        }
    }

    pub fn dein_plugins(&self) -> Vec<&DeinPlugin> {
        self.plugins.iter().filter(|x| !x.is_lazy()).collect()
    }

    pub fn dein_lazy_plugins(&self) -> Vec<&DeinPlugin> {
        self.plugins.iter().filter(|x| x.is_lazy()).collect()
    }

    pub fn output_toml(&self, output_dirpath: &str) -> Result<()> {
        self.output_dein_toml(output_dirpath)?;
        self.output_dein_lazy_toml(output_dirpath)?;

        Ok(())
    }

    pub fn output_dein_toml(&self, output_dirpath: &str) -> Result<()> {
        if !self.dein_plugins().is_empty() {
            let plugins: Vec<DeinPlugin> =
                self.dein_plugins().iter().map(|x| (*x).clone()).collect();
            let dein_toml = DeinToml::new(&plugins);
            let toml = toml::to_string_pretty(&dein_toml).unwrap();
            let mut file = File::create(Path::new(&output_dirpath).join("dein.toml"))?;
            file.write_all(toml.as_bytes())?;
        }

        Ok(())
    }

    pub fn output_dein_lazy_toml(&self, output_dirpath: &str) -> Result<()> {
        if !self.dein_lazy_plugins().is_empty() {
            let plugins: Vec<DeinPlugin> = self
                .dein_lazy_plugins()
                .iter()
                .map(|x| (*x).clone())
                .collect();
            let dein_toml = DeinToml::new(&plugins);
            let toml = toml::to_string_pretty(&dein_toml).unwrap();
            let mut file = File::create(Path::new(&output_dirpath).join("dein_lazy.toml"))?;
            file.write_all(toml.as_bytes())?;
        }

        Ok(())
    }
}

#[derive(Debug, Default, PartialEq, Clone, Serialize, Deserialize)]
pub struct DeinPlugin {
    repo: String,
    rev: Option<String>,
    on_lua: Option<Vec<String>>,
    on_event: Option<Vec<String>>,
    on_cmd: Option<Vec<String>>,
    on_map: Option<Vec<String>>,
    on_ft: Option<Vec<String>>,
    on_source: Option<Vec<String>>,
    build: Option<String>,

    hook_add: Option<String>,
    hook_source: Option<String>,
    hook_post_source: Option<String>,
    ftplugin: Option<HashMap<String, String>>,
}

impl DeinPlugin {
    pub fn is_lazy(&self) -> bool {
        if self.on_event.is_some() {
            return true;
        }
        if self.on_cmd.is_some() {
            return true;
        }
        if self.on_map.is_some() {
            return true;
        }
        if self.on_ft.is_some() {
            return true;
        }

        if self.hook_source.is_some() {
            return true;
        }
        if self.hook_post_source.is_some() {
            return true;
        }

        return false;
    }
}

impl DeinPlugin {
    pub fn from_path(path: String) -> Option<Self> {
        let basepath = Path::new(&path);
        let mut plugin = Self::default();

        let yml = PluginConfig::from_yaml(basepath.join("config.yml").to_str().unwrap()).unwrap();
        if !yml.config.enable {
            println!("Disable plugin: {}", yml.config.url);
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
        plugin.on_lua = yml.config.dein.on_lua;
        plugin.on_event = yml.config.dein.on_event;
        plugin.on_source = yml.config.dein.on_source;
        plugin.on_cmd = yml.config.commands;
        plugin.on_map = yml.config.maps;
        plugin.on_ft = yml.config.filetypes;
        plugin.build = yml.config.r#do;

        // ftplugin
        if yml.config.dein.ftplugin {
            let contents = load_file(basepath.join("ftplugin.toml").to_str().unwrap()).unwrap();
            let ftplugin: HashMap<String, String> = toml::from_str(&contents).unwrap();
            plugin.ftplugin = Some(ftplugin);
        }

        let fm = FileManager::new(&path);
        plugin.hook_add = fm.load("add.vim");
        plugin.hook_source = fm.load("preload.vim");
        plugin.hook_post_source = fm.load("postload.vim");

        Some(plugin)
    }
}

pub fn load_dein_toml(file: &str) -> Result<()> {
    let contents = load_file(file)?;
    let dein_toml: DeinToml = toml::from_str(&contents)?;

    let creator = TemplateCreator::new("./plugins".into());
    for plugin in dein_toml.plugins {
        let repo_name = plugin.repo.replace("https://github.com/", "");
        let names: Vec<&str> = repo_name.split("/").collect();
        let name = names[1].to_string();
        let res = creator.create(&name, "etc");
        match res {
            Ok(_) => {}
            Err(_) => {}
        }

        let mut config_yml = PluginConfig::default();
        config_yml.config.enable = true;
        config_yml.config.url = format!("https://github.com/{}", plugin.repo);

        // rev
        if plugin.rev.is_some() {
            config_yml.config.rev = plugin.rev;
        }

        // on_lua
        config_yml.config.dein.on_lua = plugin.on_lua;
        config_yml.config.dein.on_event = plugin.on_event;
        config_yml.config.dein.on_source = plugin.on_source;
        config_yml.config.commands = plugin.on_cmd;
        config_yml.config.maps = plugin.on_map;
        config_yml.config.filetypes = plugin.on_ft;
        config_yml.config.r#do = plugin.build;

        //ftplugin
        if plugin.ftplugin.is_some() {
            config_yml.config.dein.ftplugin = true;

            let s = toml::to_string_pretty(&plugin.ftplugin)?;
            let mut file = File::create(&format!("./plugins/etc/{}/ftplugin.toml", name))?;
            file.write_all(s.as_bytes())?;
        }

        // output config.yml
        config_yml.output_yaml(&format!("./plugins/etc/{}/config.yml", name))?;

        let fm = FileManager::new(&format!("./plugins/etc/{}", name));
        // output add.yml
        if plugin.hook_add.is_some() {
            fm.write("add.vim", plugin.hook_add.unwrap().as_bytes())?;
        }

        // output preload.yml
        if plugin.hook_source.is_some() {
            fm.write("preload.vim", plugin.hook_source.unwrap().as_bytes())?;
        }

        // output postload.yml
        if plugin.hook_post_source.is_some() {
            fm.write("postload.vim", plugin.hook_post_source.unwrap().as_bytes())?;
        }
    }

    Ok(())
}

pub struct DeinMaker {
    plugins_path: String,
}

impl DeinMaker {
    pub fn new(plugins_path: String) -> Self {
        DeinMaker {
            plugins_path: plugins_path,
        }
    }

    pub fn make(&self, output_path: String) -> Result<()> {
        let plugin_paths = find_plugin_path(Path::new(&self.plugins_path))?;

        let plugins: Vec<DeinPlugin> = plugin_paths
            .iter()
            .filter_map(|path| DeinPlugin::from_path(path.into()))
            .collect();

        let dein_toml = DeinToml::new(&plugins);
        dein_toml.output_toml(&output_path)?;

        Ok(())
    }
}
