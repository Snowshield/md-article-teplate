log   = (args...) -> console.log(args...)
error = (args...) -> console.error(args...)

compile = require './compile'

compile {
  inFilesDir  : 'content'
  outFile     : 'Report.docx'
  stylesFile  : '__style__.docx'
}
