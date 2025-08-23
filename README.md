# AI Video Generator (Vercel, Lightweight)

Minimal static site + Vercel Serverless Function that creates and polls a Replicate text-to-video prediction. Frontend is a single `index.html`. Backend is one API route at `api/prediction`.

## Quick start

1) Copy env and set your Replicate token and model

```bash
cp .env.example .env
# Set REPLICATE_API_TOKEN in your Vercel Project Settings > Environment Variables instead of committing .env
```

Configure model either by version or owner/name (recommended):
- REPLICATE_MODEL_VERSION
- or REPLICATE_MODEL_OWNER and REPLICATE_MODEL_NAME

2) Deploy on Vercel

```bash
# From project root
npm i -g vercel
vercel
# Then for production
vercel --prod
```

In the Vercel dashboard, add your environment variable(s) (Project Settings → Environment Variables). Redeploy for changes to take effect.

## API

- POST `/api/prediction`
  - Body: `{ "prompt": "A cat surfing at sunset" }`
  - Returns: `{ "id": "pred_xxx" }`
- GET `/api/prediction?id=pred_xxx`
  - Returns: `{ id, status, output, error }`

The frontend polls until `status === "succeeded"` and renders the first video URL in `output`.

## Notes

- Serverless functions have execution time limits, so this app starts the prediction and polls from the browser.
- Keep your API keys in Vercel env vars. Do not commit secrets.