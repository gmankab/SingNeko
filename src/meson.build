singularity_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
]

singularity_deps = [
  config_dep,
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

blueprints = custom_target(
  'blueprints',
  input: files(
    'gtk/help-overlay.blp',
    'window.blp',
  ),
  output: '.',
  command: [
    find_program('blueprint-compiler'),
    'batch-compile',
    '@OUTPUT@',
    '@CURRENT_SOURCE_DIR@',
    '@INPUT@',
  ],
)

singularity_sources += gnome.compile_resources(
  'singularity-resources',
  'singularity.gresource.xml',
  c_name: 'singularity',
  dependencies: blueprints,
)

executable(
  'singularity',
  singularity_sources,
  dependencies: singularity_deps,
  include_directories: config_inc,
  install: true,
)
