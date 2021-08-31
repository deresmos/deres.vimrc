mod file;
mod lib;
mod migration;
mod plugin_config;
mod plugin_manager;
mod template_creator;

use anyhow::Result;
use clap::{AppSettings, Clap};
use migration::config::PluginConfigMigrator;
use plugin_manager::dein;
use crate::template_creator::TemplateCreator;

fn main() -> Result<()> {
    let opts: Opts = Opts::parse();
    match opts.subcmd {
        SubCommand::Create(o) => {
            let creator = TemplateCreator::new(o.basedir);
            creator.create(&o.name, &o.tag)?;
        }
        SubCommand::MakeDein(o) => {
            let maker = dein::DeinMaker::new(o.plugins_dir);
            maker.make(o.output_dir).unwrap();
        }
        SubCommand::FromDein(o) => {
            dein::load_dein_toml(&o.toml_path).unwrap();
        }
        SubCommand::MigrateConfig(o) => {
            let migrator = PluginConfigMigrator::new(o.plugins_dir);
            migrator.migrate().unwrap();
        }
    }

    Ok(())
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
