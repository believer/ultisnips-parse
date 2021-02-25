import { NowRequest, NowResponse } from '@vercel/node'
import fs from 'fs'
import lineByLine from 'n-readlines'
import fetch from 'node-fetch'
import path from 'path'
import { promisify } from 'util'
import { allowCors } from '../utils/allowCors'

interface Snippet {
  body: string[]
  description: string[]
  options: string[]
  prefix: string
  title: string
}

const writeFile = promisify(fs.writeFile)
const baseUrl =
  'https://raw.githubusercontent.com/believer/dotfiles/master/coc/ultisnips/'

const getData = async (language: string | string[]): Promise<string> => {
  const response = await fetch(`${baseUrl}${language}.snippets`)
  const data = await response.text()

  // If the snippet extends another definition follow that path
  if (data.startsWith('extends')) {
    const extendedLanguage = data.split(' ')[1].trim()
    return await getData(extendedLanguage)
  }

  return data
}

const handler = async (req: NowRequest, res: NowResponse) => {
  let line: Buffer | false
  const snippets: Snippet[] = []
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
        const snippetStart = line
          .toString('ascii')
          .match(/^snippet\s(?<prefix>\w+)\s"(?<title>.+)"\s?(?<options>\w+)?$/)

        const { prefix, title, options } = snippetStart?.groups ?? {}

        line = liner.next()
        const body = []

        // Collect snippet body
        while (!line.toString('ascii').startsWith('endsnippet')) {
          body.push(line.toString('ascii'))
          line = liner.next()
        }

        snippets.push({
          body,
          description,
          prefix,
          title,
          options: options?.split(''),
        })
      }
    }

    res.json(snippets)
  } catch (e) {
    console.log(e)
  }
}

export default allowCors(handler)
