singneko_sources = [
  'main.vala',
  'application.vala',
  'gtk/window.vala',
  'gtk/outbound-row.vala',
  'gtk/subscription-dialog.vala',
]

singneko_deps = [
  config_dep,
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('libsoup-3.0'),
]

subdir('logic')

blueprints = custom_target(
  'blueprints',
  input: files(
    'gtk/help-overlay.blp',
    'gtk/outbound-row.blp',
    'gtk/subscription-dialog.blp',
    'gtk/window.blp',
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

singneko_sources += gnome.compile_resources(
  'singneko-resources',
  'singneko.gresource.xml',
  c_name: 'singneko',
  dependencies: blueprints,
)

subdir('icons')

executable(
  'singneko',
  singneko_sources,
  dependencies: singneko_deps,
  include_directories: config_inc,
  install: true,
)