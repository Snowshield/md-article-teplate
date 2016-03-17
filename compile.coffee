log   = (args...) -> console.log(args...)
error = (args...) -> console.error(args...)

{spawn} = require 'child_process'
{join}  = require 'path'
fs      = require 'fs'


isFile = (path)->
  stat = fs.statSync path
  stat.isFile()

isDir = (path)->
  stat = fs.statSync path
  stat.isDirectory()

isMd = (name)->
  pt = name.lastIndexOf('.')
  pt isnt -1 and name[pt+1...] is 'md'

#forEach directory -> concat files and save to *.md
foldersToMd = (myDir)->
  myPath  = join(__dirname, myDir)
  folders = fs.readdirSync(myPath)
  .filter (name)->
    path = join(myPath, name)
    isDir path

  folders.forEach (name)->
    folderPath    = join(myPath, name)
    folderFiles   = fs.readdirSync folderPath
    folderContents = folderFiles.filter (name)->
      absName = join(folderPath, name)
      isMd(name) and isFile(absName)
    .reduce (res, name)->
        filePath    = join(folderPath, name)
        fileContent = fs.readFileSync filePath,
          encoding : 'UTF8'
        "#{res}#{fileContent}\n"
      , ""
    fs.writeFileSync "#{folderPath}_GEN.md", folderContents,
      encoding : 'UTF8'

# CREATE list of all *.md files in directory myDir
dirMdArray = (myDir)->
  dirAbs  = join(__dirname, myDir)
  paths   = fs.readdirSync dirAbs
  isMd    = (name)->
    pt = name.lastIndexOf('.')
    pt isnt -1 and name[pt+1...] is 'md'
  filesMd = paths.filter (name)->
    absName = join(dirAbs, name)
    isMd(name) and isFile(absName)


module.exports = ({inFilesDir, outFile, stylesFile})->
  foldersToMd inFilesDir
  inFiles = dirMdArray(inFilesDir).map (item)->
    join(inFilesDir, item)

  styles  = join('styles', stylesFile)

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
