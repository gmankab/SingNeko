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

singularity_sources += gnome.compile_resources('singularity-resources',
  'singularity.gresource.xml',
  c_name: 'singularity'
)

executable('singularity', singularity_sources,
  dependencies: singularity_deps,
  include_directories: config_inc,
       install: true,
)
