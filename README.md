# EAaC - Enterprise Architecture as Code

This repository contains an ArchiMate model that is automatically published to GitHub Pages whenever the `model.archimate` file is updated.

## Setup

### Enable GitHub Pages

**Important:** GitHub Pages must be enabled before the workflow can deploy.

1. Go to your repository settings on GitHub
2. Navigate to "Pages" in the left sidebar
3. Under "Source", select **"GitHub Actions"** (not "Deploy from a branch")
4. Save the changes

**Note:** If you see an error "Get Pages site failed", it means Pages is not enabled yet. Enable it manually using the steps above, then re-run the workflow.

**First Deployment:** The first deployment can take 5-10 minutes as GitHub Pages initializes. The deployment will show "deployment_queued" status during this time - this is normal. Subsequent deployments are much faster (usually 1-2 minutes).

The workflow will automatically:
- Trigger on commits to `model.archimate` on `main` branch or feature branches (`feature/**`, `feat/**`)
- Also triggers on pull requests that modify `model.archimate`
- Generate an HTML preview of the ArchiMate model
- Deploy to GitHub Pages:
  - **Main branch**: Deploys to production (your main site)
  - **Feature branches/PRs**: Deploys as preview (accessible via preview URLs in the deployment)

## Local Development

To generate the HTML preview locally using Archi's built-in HTML Report plugin:

1. Install [Archi](https://www.archimatetool.com/downloads/) on your system
2. Run the following command:

```bash
Archi -consoleLog -nosplash \
  -application com.archimatetool.commandline.app \
  --loadModel model.archimate \
  --html.createReport docs/
```

Then open `docs/index.html` in your browser.

## Model Structure

The model is stored in `model.archimate` using the ArchiMate XML format compatible with the Archi tool.

## Workflow

The GitHub Actions workflow (`.github/workflows/publish-pages.yml`) automatically:
1. Detects changes to `model.archimate`
2. Downloads and sets up Archi
3. Generates an HTML report using Archi's built-in HTML Report plugin
4. Publishes the result to GitHub Pages

## Viewing the Model

### Production (Main Branch)
Once GitHub Pages is enabled, your model will be available at:
- **Default URL:** `https://<your-username>.github.io/<repository-name>/`
- **Custom Domain:** If configured, the site will be at the root of your domain (e.g., `https://yourdomain.com/`)

### Preview Deployments (Feature Branches/PRs)
When you push to a feature branch or create a pull request:
- The workflow automatically creates a **preview deployment**
- Preview URLs are available in:
  - The GitHub Actions workflow run summary
  - The pull request page (if deploying from a PR)
  - The deployment status in your repository's "Environments" section

#### How Pull Requests Work

When you create a PR against `main` that modifies `model.archimate`:

1. **Automatic Trigger**: The workflow runs automatically when:
   - A PR is opened
   - New commits are pushed to the PR branch
   - The PR is reopened

2. **Preview Deployment**: 
   - The workflow checks out the **PR branch** (source branch)
   - Generates the HTML report from that branch's `model.archimate`
   - Deploys it as a **preview** (not production)
   - Each PR gets its own unique preview URL

3. **Finding the Preview URL**:
   - **In the PR**: Look for a "View deployment" link in the PR conversation or checks section
   - **In Actions**: Go to the workflow run → "Deploy to GitHub Pages" step → Check the deployment status
   - **In Environments**: Repository → Environments → Click on the deployment

4. **What Gets Deployed**:
   - Only the changes from the PR branch are deployed
   - The preview shows how the model will look after merging
   - Production site (`main` branch) remains unchanged

5. **After Merging**:
   - When the PR is merged to `main`, the workflow runs again
   - This time it deploys to **production** (your main site)
   - The preview deployment is automatically cleaned up

**Note:** GitHub Pages doesn't support subdirectory paths on custom domains. If you need the site at a subdirectory like `/EAaC/`, you have these options:
1. Use the default GitHub Pages URL (includes the repository name in the path)
2. Use a subdomain instead (e.g., `eac.yourdomain.com`)
3. Configure a reverse proxy on your web server to route `/EAaC/` to the GitHub Pages site

## Testing Locally

To test the workflow locally before pushing to GitHub, see [TESTING.md](TESTING.md) for detailed instructions.

Quick test options:
- **Using `act`** (recommended): `brew install act && act push`
- **Manual test script**: `./test-workflow.sh`
- **Step-by-step**: See TESTING.md for manual testing instructions

