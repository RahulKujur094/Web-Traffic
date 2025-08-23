const API_BASE = 'https://api.replicate.com/v1';

function json(res, status, data) {
  res.statusCode = status;
  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify(data));
}

function getAuthHeader() {
  const token = process.env.REPLICATE_API_TOKEN || process.env.REPLICATE_API_KEY || process.env.REPLICATE_TOKEN;
  if (!token) return null;
  return { Authorization: `Token ${token}` };
}

async function createPrediction(prompt) {
  const headers = {
    ...getAuthHeader(),
    'Content-Type': 'application/json'
  };
  const version = process.env.REPLICATE_MODEL_VERSION;
  const owner = process.env.REPLICATE_MODEL_OWNER;
  const name = process.env.REPLICATE_MODEL_NAME;

  const input = { prompt };
  const body = JSON.stringify(version ? { version, input } : { input });

  const endpoint = version
    ? `${API_BASE}/predictions`
    : (owner && name)
      ? `${API_BASE}/models/${encodeURIComponent(owner)}/${encodeURIComponent(name)}/predictions`
      : null;

  if (!endpoint) {
    throw new Error('Model not configured. Set REPLICATE_MODEL_VERSION or REPLICATE_MODEL_OWNER and REPLICATE_MODEL_NAME.');
  }

  const res = await fetch(endpoint, { method: 'POST', headers, body });
  if (!res.ok) {
    const t = await res.text();
    throw new Error(`Replicate create failed (${res.status}): ${t}`);
  }
  const data = await res.json();
  return { id: data.id };
}

async function getPrediction(id) {
  const headers = {
    ...getAuthHeader(),
    'Content-Type': 'application/json'
  };
  const res = await fetch(`${API_BASE}/predictions/${encodeURIComponent(id)}`, { headers });
  if (!res.ok) {
    const t = await res.text();
    throw new Error(`Replicate fetch failed (${res.status}): ${t}`);
  }
  const data = await res.json();
  // Normalize output
  const output = data.output ?? null;
  const status = data.status || 'unknown';
  const error = data.error || null;
  return { id: data.id, status, output, error };
}

module.exports = async (req, res) => {
  try {
    const auth = getAuthHeader();
    if (!auth) return json(res, 500, { error: 'Missing REPLICATE_API_TOKEN in environment' });

    if (req.method === 'OPTIONS') {
      res.setHeader('Access-Control-Allow-Origin', '*');
      res.setHeader('Access-Control-Allow-Methods', 'POST,GET,OPTIONS');
      res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
      return res.status(200).end();
    }

    if (req.method === 'POST') {
      const chunks = [];
      for await (const c of req) chunks.push(c);
      const bodyStr = Buffer.concat(chunks).toString('utf8') || '{}';
      let body;
      try { body = JSON.parse(bodyStr); } catch { body = {}; }
      const prompt = (body && body.prompt ? String(body.prompt) : '').trim();
      if (!prompt) return json(res, 400, { error: 'Prompt is required' });

      const created = await createPrediction(prompt);
      return json(res, 200, created);
    }

    if (req.method === 'GET') {
      const url = new URL(req.url, `https://${req.headers.host}`);
      const id = url.searchParams.get('id');
      if (!id) return json(res, 400, { error: 'Missing id' });
      const current = await getPrediction(id);
      return json(res, 200, current);
    }

    return json(res, 405, { error: 'Method not allowed' });
  } catch (err) {
    return json(res, 500, { error: err.message || String(err) });
  }
};