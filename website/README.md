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

## Deploying to Cloudflare Workers

The site is served at https://promptzeppelin.com as static assets on Cloudflare Workers, the same setup as the Swooping Magpies site. The domain is registered with Cloudflare. `wrangler.toml` tells Wrangler to upload the generated `public/` folder; no Worker script is needed.

### 1. Create the Worker

In the Cloudflare dashboard, go to **Workers & Pages → Create → Import a repository**, pick `Codercise/prompt-zeppelin`, and use these settings:

| Setting | Value |
| --- | --- |
| Worker name | `prompt-zeppelin` (must match `name` in `wrangler.toml`) |
| Production branch | `main` |
| Root directory | `website` |
| Build command | `hugo --minify` |
| Deploy command | `npx wrangler deploy` |
| Build environment variable (Production and Preview) | `HUGO_VERSION=0.157.0` |

The Hugo version matches the locally verified build. After the first build succeeds, future pushes to `main` deploy automatically.

To check the configuration locally without publishing:

```sh
hugo --minify
npx wrangler deploy --dry-run
```

### 2. Only rebuild when the site changes

In the Worker's **Settings → Build**, set **Build watch paths** to include only `website/*`, so commits that only touch the app don't trigger a deploy.

### 3. Connect the domain

1. In the Worker, go to **Settings → Domains & Routes → Add → Custom Domain** and enter `promptzeppelin.com`. Cloudflare manages the DNS record and HTTPS certificate.
2. Repeat for `www.promptzeppelin.com`.
3. To send `www` to the main address, go to the `promptzeppelin.com` zone, then **Rules → Redirect Rules → Create rule → Templates → Redirect from WWW to root**.

Changing `baseURL` in Hugo or pushing the repo doesn't register the domain with Cloudflare; the custom domain step above is still required.

### Other files

- `static/_headers` sets security headers, and long-term caching for the fingerprinted stylesheet.
- `static/robots.txt` points search engines at the sitemap, which Hugo generates.
- `wrangler.toml` serves `404.html` for missing pages (`not_found_handling = "404-page"`).
