utils_sources = 'logic/utils.vala'
config_sources = 'logic/config.vala'

singneko_deps += [
  dependency('json-glib-1.0'),
  dependency('gee-0.8'),
]

subdir('transports')
subdir('outbounds')
singneko_sources += [
  utils_sources,
  outbounds_sources,
  transports_sources,
  config_sources,
  'logic/tls.vala',
  'logic/error.vala',
  'logic/singbox.vala',
]
