use anyhow::{Context, Result};
use clap::{AppSettings, Clap};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;
use std::fs::File;
use std::io::prelude::*;
use std::io::{Error, ErrorKind};
use std::path::Path;
use toml;
// TODO: ftplugin

fn main() -> Result<()> {
    let opts: Opts = Opts::parse();
    match opts.subcmd {
        SubCommand::Create(o) => {
            let creator = TemplateCreator::new(o.basedir);
            creator.create(&o.name, &o.tag)?;
        }
        SubCommand::MakeDein(o) => {
            let maker = DeinMaker::new(o.plugins_dir);
            maker.make(o.output_dir).unwrap();
        }
        SubCommand::FromDein(o) => {
            load_dein_toml(&o.toml_path).unwrap();
        }
        SubCommand::MigrateConfig(o) => {
            let migrator = ConfigMigrator::new(o.plugins_dir);
            migrator.migrate().unwrap();
        }
    }

    Ok(())
}

// yaml struct
#[derive(Debug, Default, PartialEq, Serialize, Deserialize)]
struct Config {
    url: String,
    rev: Option<String>,
    filetypes: Option<Vec<String>>,
    commands: Option<Vec<String>>,
    maps: Option<Vec<String>>,
    r#do: Option<String>,
    enable: bool,
    // dein
    dein: DeinConfig,
}

#[derive(Debug, Default, PartialEq, Serialize, Deserialize)]
struct ConfigYaml {
    config: Config,
}

#[derive(Debug, Default, PartialEq, Serialize, Deserialize)]
struct DeinConfig {
    ftplugin: bool,
    on_lua: Option<Vec<String>>,
    on_event: Option<Vec<String>>,
    on_source: Option<Vec<String>>,
}

fn load_file(file: &str) -> Result<String> {
    let mut file = File::open(file).with_context(|| format!("failed to open file: {}", file))?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)
        .expect("Unable to read file");

    Ok(contents)
}

fn load_config(file: &str) -> Result<ConfigYaml> {
    let contents = load_file(file)?;
    let config: ConfigYaml = serde_yaml::from_str(&contents)?;

    Ok(config)
}

fn output_yaml(yaml: &ConfigYaml, filepath: &str) -> Result<()> {
    let s = serde_yaml::to_string(&yaml)?;

    let mut file = File::create(filepath)?;
    file.write_all(s.as_bytes())?;

    Ok(())
}

struct TemplateCreator {
    basepath: String,
}

impl TemplateCreator {
    pub fn new(basepath: String) -> Self {
        TemplateCreator { basepath: basepath }
    }

    pub fn create(&self, name: &str, tag: &str) -> Result<()> {
        let mut config_yaml = ConfigYaml::default();
        config_yaml.config.enable = true;

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
        output_yaml(&config_yaml, &config_path.to_str().unwrap())?;

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

struct FileManager {
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

// dein
#[derive(Debug, Default, PartialEq, Serialize, Deserialize)]
struct DeinToml {
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
struct DeinPlugin {
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

        let yml = load_config(basepath.join("config.yml").to_str().unwrap()).unwrap();
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

fn load_dein_toml(file: &str) -> Result<()> {
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

        let mut config_yml = ConfigYaml::default();
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
        output_yaml(&config_yml, &format!("./plugins/etc/{}/config.yml", name))?;

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

fn find_plugin_path(path: &Path) -> Result<Vec<String>> {
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

    Ok(dir_paths)
}

struct DeinMaker {
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

struct ConfigMigrator {
    plugins_path: String,
}

impl ConfigMigrator {
    pub fn new(plugins_path: String) -> Self {
        ConfigMigrator{
            plugins_path: plugins_path,
        }
    }

    pub fn migrate(&self) -> Result<()> {
        let plugin_paths = find_plugin_path(Path::new(&self.plugins_path))?;

        for path in plugin_paths {
            let _path = Path::new(&path).join("config.yml");
            let config_path = _path.to_str().unwrap();
            let config = load_config(config_path).unwrap();

            let s = serde_yaml::to_string(&config)?;
            let mut file = File::create(config_path)?;
            file.write_all(s.as_bytes())?;
        }

        Ok(())
    }
}

#[derive(Clap)]
#[clap(version = "1.0", author = "deresmos <deresmos@gmail.com>")]
#[clap(setting = AppSettings::ColoredHelp)]
struct Opts {
    #[clap(subcommand)]
    subcmd: SubCommand,
}
#[derive(Clap)]
enum SubCommand {
    /// create plugin template
    Create(CreateOpts),

    /// make dein
    MakeDein(MakeDeinOpts),

    /// from dein toml
    FromDein(FromDeinOpts),

    /// migrate config.yml
    MigrateConfig(MigrateConfigOpts),
}

#[derive(Clap)]
struct CreateOpts {
    /// plugin name
    #[clap(name = "name")]
    name: String,

    /// tag
    #[clap(short, long, default_value = "etc")]
    tag: String,

    /// basedir
    #[clap(short, long, default_value = "plugins")]
    basedir: String,
}

#[derive(Clap)]
struct MakeDeinOpts {
    /// plugin name
    #[clap(name = "output_dir")]
    output_dir: String,

    /// basedir
    #[clap(short, long, default_value = "plugins")]
    plugins_dir: String,
}

#[derive(Clap)]
struct FromDeinOpts {
    /// plugin name
    #[clap(name = "toml_path")]
    toml_path: String,
}

#[derive(Clap)]
struct MigrateConfigOpts {
    /// basedir
    #[clap(short, long, default_value = "plugins")]
    plugins_dir: String,
}

