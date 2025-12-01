# Testing the Workflow Locally

This guide explains how to test the GitHub Actions workflow locally before pushing to GitHub.

## Option 1: Using `act` (Recommended)

The `act` tool simulates GitHub Actions workflows locally using Docker.

### Installation

```bash
# macOS
brew install act

# Or install from: https://github.com/nektos/act
```

### Run the Workflow

```bash
# Run the workflow
act push

# Or simulate a specific event
act workflow_dispatch
```

**Note:** The workflow requires Docker to be running. The first run will download the GitHub Actions runner image.

## Option 2: Manual Testing (Step-by-Step)

Test the workflow steps manually on your local machine:

### Prerequisites

1. **Install Java 17+**
   ```bash
   # macOS (Homebrew)
   brew install openjdk@17
   
   # Verify installation
   java -version
   ```

2. **Download Archi**
   - Visit: https://www.archimatetool.com/downloads/
   - Download the macOS version (or Linux if testing on Linux)
   - Extract to a temporary location

### Test Steps

1. **Check Java**
   ```bash
   java -version
   ```

2. **Download Archi** (if not already downloaded)
   ```bash
   # For macOS (Intel)
   curl -L -o Archi-macosx-5.0.0.tar.gz \
     https://www.archimatetool.com/downloads/archi/Archi-macosx-5.0.0.tar.gz
   
   # For macOS (Apple Silicon)
   curl -L -o Archi-macosx-aarch64-5.0.0.tar.gz \
     https://www.archimatetool.com/downloads/archi/Archi-macosx-aarch64-5.0.0.tar.gz
   
   # Extract
   tar -xzf Archi-*.tar.gz
   ```

3. **Find the Archi executable**
   ```bash
   # macOS
   find Archi -name "Archi" -type f
   # Usually: Archi/Archi.app/Contents/MacOS/Archi
   ```

4. **Generate HTML Report**
   ```bash
   # macOS
   Archi/Archi.app/Contents/MacOS/Archi \
     -consoleLog \
     -nosplash \
     -application com.archimatetool.commandline.app \
     --loadModel model.archimate \
     --html.createReport docs/
   
   # Linux
   Archi/Archi \
     -consoleLog \
     -nosplash \
     -application com.archimatetool.commandline.app \
     --loadModel model.archimate \
     --html.createReport docs/
   ```

5. **Verify Output**
   ```bash
   ls -la docs/
   # Should see index.html and other files
   
   # Open in browser
   open docs/index.html  # macOS
   # or
   xdg-open docs/index.html  # Linux
   ```

## Option 3: Using the Test Script

A test script is provided to automate the manual testing:

```bash
./test-workflow.sh
```

**Note:** This script requires:
- Java 17+ installed and in PATH
- Internet connection to download Archi
- Appropriate permissions to create directories

## Troubleshooting

### Java Not Found
- Ensure Java is installed: `brew install openjdk@17`
- Add to PATH if needed
- On macOS, you may need to create a symlink:
  ```bash
  sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk \
    /Library/Java/JavaVirtualMachines/openjdk-17.jdk
  ```

### Archi Download Fails
- Check your internet connection
- Visit https://www.archimatetool.com/downloads/ manually
- Download and extract Archi manually to the `Archi/` directory

### Archi Executable Not Found
- On macOS, the executable is usually at:
  `Archi/Archi.app/Contents/MacOS/Archi`
- On Linux, it's usually at:
  `Archi/Archi`
- Use `find Archi -name "Archi" -type f` to locate it

### HTML Report Not Generated
- Check the console output for errors
- Ensure `model.archimate` exists and is valid
- Try running Archi with GUI first to verify the model loads:
  ```bash
  open Archi/Archi.app  # macOS
  ```

## Expected Output

After successful execution, you should see:
- `docs/index.html` - Main HTML file
- `docs/` directory with additional assets (CSS, JS, images)
- The HTML report should be viewable in a web browser

