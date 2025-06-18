utils_sources = 'logic/utils.vala'

singularity_deps += [
  dependency('json-glib-1.0'),
  dependency('gee-0.8'),
]

subdir('transports')
subdir('outbounds')
singularity_sources += [
  utils_sources,
  outbounds_sources,
  transports_sources,
]
