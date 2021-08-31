use crate::lib::find_plugin_path;
use crate::plugin_config::PluginConfig;
use anyhow::Result;
use std::path::Path;

pub struct PluginConfigMigrator {
    plugins_path: String,
}

impl PluginConfigMigrator {
    pub fn new(plugins_path: String) -> Self {
        PluginConfigMigrator {
            plugins_path: plugins_path,
        }
    }

    pub fn migrate(&self) -> Result<()> {
        let plugin_paths = find_plugin_path(Path::new(&self.plugins_path))?;

        for path in plugin_paths {
            let _path = Path::new(&path).join("config.yml");
            let config_path = _path.to_str().unwrap();

            let plugin_config = PluginConfig::from_yaml(config_path).unwrap();
            plugin_config.output_yaml(config_path)?;
        }

        Ok(())
    }
}
