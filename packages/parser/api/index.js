const lineByLine = require('n-readlines')
const fetch = require('node-fetch')
const fs = require('fs')
const { promisify } = require('util')
const path = require('path')
const { allowCors } = require('../utils/allowCors')

const writeFile = promisify(fs.writeFile)
const baseUrl =
  'https://raw.githubusercontent.com/believer/dotfiles/master/coc/ultisnips/'

const getData = async (language) => {
  const response = await fetch(`${baseUrl}${language}.snippets`)
  const data = await response.text()

  // If the snippet extends another definition follow that path
  if (data.startsWith('extends')) {
    const extendedLanguage = data.split(' ')[1].trim()
    return await getData(extendedLanguage)
  }

  return data
}

const handler = async (req, res) => {
  let line
  const snippets = []
  const { language } = req.query

  try {
    // Save the snippet file locally
    const fileName = path.join('/tmp', `${language}.snippets`)
    const data = await getData(language)
    await writeFile(fileName, data)

    const liner = new lineByLine(fileName)

    while ((line = liner.next())) {
      // Only documented snippets are included
      // Documentation starts with a comment #
      if (line.toString('ascii').startsWith('#')) {
        const description = []

        // Collect documentation
        while (!line.toString('ascii').startsWith('snippet')) {
          description.push(line.toString('ascii').substring(2))
          line = liner.next()
        }

        // Parse snippet start
        const {
          groups: { prefix, title, options },
        } = line
          .toString('ascii')
          .match(/^snippet\s(?<prefix>\w+)\s"(?<title>.+)"\s?(?<options>\w+)?$/)

        line = liner.next()
        const body = []

        // Collect snippet body
        while (!line.toString('ascii').startsWith('endsnippet')) {
          body.push(line.toString('ascii'))
          line = liner.next()
        }

        snippets.push({
          description,
          prefix,
          title,
          body,
          options: options?.split(''),
        })
      }
    }

    res.json(snippets)
  } catch (e) {
    console.log(e)
  }
}

module.exports = allowCors(handler)
