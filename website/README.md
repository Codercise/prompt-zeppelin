# Prompt Zeppelin website

The marketing site for Prompt Zeppelin, built with [Hugo](https://gohugo.io). It lives outside the `PromptZeppelin/` app folder, so XcodeGen never includes it in the Xcode project.

## Running locally

```bash
cd website
hugo server
```

Then open http://localhost:1313.

## Editing

- Page layout and copy: `layouts/home.html`
- Feature list: `data/features.yaml`
- Styles: `assets/css/main.css`
- Screenshots and icons: `static/images/`
- Site settings (URL, GitHub link, copyright): `hugo.toml`

## Deploying to Cloudflare Pages

1. In the Cloudflare dashboard, go to **Workers & Pages → Create → Pages → Connect to Git** and pick this repo.
2. Use these build settings:
   - **Framework preset:** Hugo
   - **Build command:** `hugo --minify`
   - **Build output directory:** `public`
   - **Root directory:** `website`
3. Under **Environment variables**, add `HUGO_VERSION` = `0.157.0` so Cloudflare builds with the same Hugo version as your Mac.
4. Under **Settings → Builds → Build watch paths**, include only `website/*`, so commits to the app don't trigger a site rebuild.

When the site has its final address (a `*.pages.dev` URL or a custom domain), update `baseURL` in `hugo.toml` to match.
