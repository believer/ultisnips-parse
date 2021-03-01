import { NowRequest, NowResponse } from '@vercel/node'
import fetch from 'node-fetch'
import { allowCors } from '../utils/allowCors'

interface Snippet {
  name: string
}

const handler = async (_req: NowRequest, res: NowResponse) => {
  const response = await fetch(
    'https://api.github.com/repos/believer/dotfiles/contents/coc/ultisnips'
  )
  const data: Snippet[] = await response.json()
  const languages = data.map(({ name }) => name.replace('.snippets', ''))

  res.json(languages)
}

export default allowCors(handler)
