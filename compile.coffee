log   = (args...) -> console.log(args...)
error = (args...) -> console.error(args...)

{spawn}       = require 'child_process'
path          = require 'path'

module.exports = ({inFiles, outFile, stylesFile})->
  contentFolder = 'content'

  inFiles = inFiles.map (item)->
    path.join(contentFolder, item)

  styles  = path.join('styles', stylesFile)

  args = inFiles.concat [
    "-o #{outFile}"
    "--reference-docx=#{styles}"
  ]
  child = spawn('pandoc', args)
  # child.stdout.on 'data', log
  # child.stderr.on 'data', error
  child.on 'close', (code) ->
    successMsg = "SUCCESS: #{outFile} was successfully compiled"
    errorMsg   = "ERROR: #{outFile} can't be compiled (code #{code})"
    switch code
      when 0 then log successMsg
      else log errorMsg
