mod file;
mod lib;
mod migration;
mod plugin_config;
mod plugin_manager;
mod template_creator;

use crate::template_creator::TemplateCreator;
use anyhow::Result;
extern crate clap;
use clap::Parser;
use env_logger;
use log::error;
use migration::config::PluginConfigMigrator;
use plugin_manager::packer;

fn main() -> Result<()> {
    env_logger::init();

    let opts: Opts = Opts::parse();
    match opts.subcmd {
        SubCommand::Create(o) => {
            let creator = TemplateCreator::new(o.basedir);
            creator.create(&o.name, &o.tag)?;
        }
        SubCommand::Make(o) => match &*o.plugin_manager {
            "packer" => {
                let maker = packer::PackerMaker::new(o.plugins_dir);
                maker.make(o.output_dir).unwrap();
            }
            _ => {
                error!("'{}' plugin manager not support", o.plugin_manager);
                std::process::exit(0);
            }
        },
        SubCommand::From(o) => match &*o.plugin_manager {
            _ => {
                error!("'{}' plugin manager not support", o.plugin_manager);
                std::process::exit(0);
            }
        },
        SubCommand::MigrateConfig(o) => {
            let migrator = PluginConfigMigrator::new(o.plugins_dir);
            migrator.migrate().unwrap();
        }
    }

    Ok(())
}

#[derive(Parser)]
#[clap(version = "1.0")]
// #[clap(setting = AppSettings::ColoredHelp)]
struct Opts {
    #[clap(subcommand)]
    subcmd: SubCommand,
}

#[derive(Parser)]
enum SubCommand {
    /// create plugin template
    Create(CreateOpts),

    /// make dein
    Make(MakeOpts),

    /// from dein toml
    From(FromOpts),

    /// migrate config.yml
    MigrateConfig(MigrateConfigOpts),
}

#[derive(Parser)]
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

#[derive(Parser)]
struct MakeOpts {
    /// output dir
    #[clap(name = "output_dir")]
    output_dir: String,

    /// plugins basedir
    #[clap(short, long, default_value = "plugins")]
    plugins_dir: String,

    /// plugin manger name
    #[clap(short = 'm', long, default_value = "dein")]
    plugin_manager: String,
}

#[derive(Parser)]
struct FromOpts {
    /// file path
    #[clap(name = "filepath")]
    filepath: String,

    /// plugin manger name
    #[clap(short = 'm', long, default_value = "dein")]
    plugin_manager: String,
}

#[derive(Parser)]
struct MigrateConfigOpts {
    /// basedir
    #[clap(short, long, default_value = "plugins")]
    plugins_dir: String,
}
