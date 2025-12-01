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

The workflow will automatically:
- Trigger on commits to `model.archimate`
- Generate an HTML preview of the ArchiMate model
- Deploy it to GitHub Pages

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

Once GitHub Pages is enabled, your model will be available at:
`https://<your-username>.github.io/<repository-name>/`

## Testing Locally

To test the workflow locally before pushing to GitHub, see [TESTING.md](TESTING.md) for detailed instructions.

Quick test options:
- **Using `act`** (recommended): `brew install act && act push`
- **Manual test script**: `./test-workflow.sh`
- **Step-by-step**: See TESTING.md for manual testing instructions

