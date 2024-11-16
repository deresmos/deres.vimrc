require("flutter-tools").setup {}
require('flutter-tools').setup_project({
  {
    name = 'Development', -- an arbitrary name that you provide so you can recognise this config
    dart_define_from_file = 'flavor/dev.json' -- the path to a JSON configuration file
  },
  {
    name = 'Profile',
    flutter_mode = 'profile',
  }
})
