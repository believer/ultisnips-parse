import { NowRequest, NowResponse } from '@vercel/node'
import fetch from 'node-fetch'
import { allowCors } from '../utils/allowCors'

interface Snippet {
  name: string
}

const languageName = {
  elixir: 'Elixir',
  elm: 'Elm',
  eruby: 'ERuby',
  gitcommit: 'Git Commit',
  javascript: 'JavaScript',
  javascriptreact: 'JavaScript React',
  rails: 'Ruby on Rails',
  reason: 'ReasonML',
  rescript: 'ReScript',
  ruby: 'Ruby',
  rust: 'Rust',
  snippets: 'UltiSnips snippets',
  typescript: 'TypeScript',
  typescriptreact: 'TypeScript React',
}

const handler = async (_req: NowRequest, res: NowResponse) => {
  try {
    const response = await fetch(
      'https://api.github.com/repos/believer/dotfiles/contents/coc/ultisnips'
    )
    const data: Snippet[] = await response.json()
    const languages = (data ?? []).map(({ name }) => {
      const id = name.replace('.snippets', '') as keyof typeof languageName

      return {
        id,
        name: languageName[id] ?? id,
      }
    })

    res.json(languages)
  } catch (e) {
    res.json([])
  }
}

export default allowCors(handler)
