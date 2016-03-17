log   = (args...) -> console.log(args...)
error = (args...) -> console.error(args...)

path    = require 'path'
compile = require './compile'

inFiles = [
  'example.md'
]

compile {
  inFiles
  outFile     : 'Report.docx'
  stylesFile  : '__style__.docx'
}
