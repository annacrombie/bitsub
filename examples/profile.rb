# A full example showing most of the features of bitsub

# Set the base download directory
dir File.join(Dir.home, 'media/vid/anime/airing')

# Each subscription is of the format
#
# sub <folder>, <pattern>
#
# RSS results matching pattern will be created, with the download_dir
# attribute set to <base_download_dir>/<folder>
#
# For more information on the regular expression flavor, see `ri Regexp`
sub '色づく世界の明日から', /horrible.*irozuku.*720/i
sub '骸骨書店員本田さん', /horrible.*gaikotsu.*honda.*720/i

# Each feed is of the format
#
# feed <uri>
feed 'https://nyaa.si/?page=rss&c=1_2&f=2&q=horrible+irozuku'
feed 'https://nyaa.si/?page=rss&c=1_2&f=2&q=gaikotsu+honda'

# This formatter is mapped over the resulting array of results
setting output_fmt: ->(t) { "--add #{t[:link]} --download-dir #{t[:download_dir]}" }

# The result of the above map is joined with the following string
setting output_sep: "\0"

# Then from the command line:
#
# bitsub | xargs -0 -n 4 transmission-remote
#
# Will add all torrents to transmission
