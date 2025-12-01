#!/bin/bash
# Local test script to simulate the GitHub Actions workflow
# This script tests Archi HTML report generation locally

set -e  # Exit on error

echo "=== Testing Archi HTML Report Generation ==="
echo ""

# Step 1: Check Java
echo "Step 1: Checking Java installation..."
if ! command -v java &> /dev/null; then
    echo "WARNING: Java is not installed or not in PATH."
    echo ""
    echo "Please install Java 17 or later:"
    echo "  - macOS (Homebrew): brew install openjdk@17"
    echo "  - Or download from: https://adoptium.net/"
    echo ""
    echo "After installing, you may need to:"
    echo "  sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk"
    echo ""
    read -p "Press Enter to continue anyway (will likely fail) or Ctrl+C to cancel..."
    echo ""
else
    JAVA_VERSION=$(java -version 2>&1 | head -1)
    echo "✓ Found: $JAVA_VERSION"
    echo ""
fi

# Step 2: Determine OS and Archi download URL
echo "Step 2: Detecting OS and preparing Archi download..."
OS="$(uname -s)"
ARCH="$(uname -m)"

if [[ "$OS" == "Darwin" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
        ARCHI_PLATFORM="macosx-aarch64"
    else
        ARCHI_PLATFORM="macosx"
    fi
    ARCHI_EXT="tar.gz"
elif [[ "$OS" == "Linux" ]]; then
    ARCHI_PLATFORM="Linux64"
    ARCHI_EXT="tar.gz"
else
    echo "ERROR: Unsupported OS: $OS"
    exit 1
fi

echo "✓ Detected OS: $OS ($ARCH)"
echo "✓ Archi platform: $ARCHI_PLATFORM"
echo ""

# Step 3: Download Archi
echo "Step 3: Downloading Archi..."
ARCHI_VERSION="5.0.0"
ARCHI_URL="https://www.archimatetool.com/downloads/archi/Archi-${ARCHI_PLATFORM}-${ARCHI_VERSION}.${ARCHI_EXT}"

if [ -d "Archi" ]; then
    echo "✓ Archi directory already exists, skipping download"
else
    echo "Downloading from: $ARCHI_URL"
    if curl -L -f -o "Archi-${ARCHI_PLATFORM}-${ARCHI_VERSION}.${ARCHI_EXT}" "$ARCHI_URL" 2>/dev/null; then
        echo "✓ Download successful"
        tar -xzf "Archi-${ARCHI_PLATFORM}-${ARCHI_VERSION}.${ARCHI_EXT}"
        rm "Archi-${ARCHI_PLATFORM}-${ARCHI_VERSION}.${ARCHI_EXT}"
        echo "✓ Extracted Archi"
    else
        echo "Version ${ARCHI_VERSION} not found, trying 4.9.1..."
        ARCHI_VERSION="4.9.1"
        ARCHI_URL="https://www.archimatetool.com/downloads/archi/Archi-${ARCHI_PLATFORM}-${ARCHI_VERSION}.${ARCHI_EXT}"
        if curl -L -f -o "Archi-${ARCHI_PLATFORM}-${ARCHI_VERSION}.${ARCHI_EXT}" "$ARCHI_URL" 2>/dev/null; then
            echo "✓ Download successful (version 4.9.1)"
            tar -xzf "Archi-${ARCHI_PLATFORM}-${ARCHI_VERSION}.${ARCHI_EXT}"
            rm "Archi-${ARCHI_PLATFORM}-${ARCHI_VERSION}.${ARCHI_EXT}"
            echo "✓ Extracted Archi"
        else
            echo "ERROR: Failed to download Archi"
            exit 1
        fi
    fi
fi

# Find the Archi executable
if [[ "$OS" == "Darwin" ]]; then
    ARCHI_EXEC="Archi/Archi.app/Contents/MacOS/Archi"
    if [ ! -f "$ARCHI_EXEC" ]; then
        # Try alternative location
        ARCHI_EXEC="Archi/Archi"
    fi
else
    ARCHI_EXEC="Archi/Archi"
fi

if [ ! -f "$ARCHI_EXEC" ]; then
    echo "ERROR: Archi executable not found at $ARCHI_EXEC"
    echo "Looking for Archi in:"
    find Archi -name "Archi" -type f 2>/dev/null || echo "No Archi executable found"
    exit 1
fi

chmod +x "$ARCHI_EXEC"
echo "✓ Archi executable found: $ARCHI_EXEC"
echo ""

# Step 4: Check model file
echo "Step 4: Checking model file..."
if [ ! -f "model.archimate" ]; then
    echo "ERROR: model.archimate not found"
    exit 1
fi
echo "✓ Found model.archimate"
echo ""

# Step 5: Create docs directory
echo "Step 5: Preparing output directory..."
mkdir -p docs
echo "✓ Created docs/ directory"
echo ""

# Step 6: Generate HTML Report
echo "Step 6: Generating HTML report using Archi..."
echo "Running: $ARCHI_EXEC -consoleLog -nosplash -application com.archimatetool.commandline.app --loadModel model.archimate --html.createReport docs/"
echo ""

"$ARCHI_EXEC" \
    -consoleLog \
    -nosplash \
    -application com.archimatetool.commandline.app \
    --loadModel model.archimate \
    --html.createReport docs/

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ HTML report generated successfully!"
    echo ""
    
    # Step 7: Check results
    echo "Step 7: Checking generated files..."
    if [ -f "docs/index.html" ]; then
        echo "✓ Found docs/index.html"
        FILE_SIZE=$(ls -lh docs/index.html | awk '{print $5}')
        echo "  File size: $FILE_SIZE"
        
        # Count files in docs
        FILE_COUNT=$(find docs -type f | wc -l | tr -d ' ')
        echo "  Total files in docs/: $FILE_COUNT"
        
        echo ""
        echo "=== SUCCESS ==="
        echo "HTML report generated in docs/ directory"
        echo "Open docs/index.html in your browser to view the report"
    else
        echo "WARNING: docs/index.html not found, but command completed"
        echo "Checking docs/ directory contents:"
        ls -la docs/ || echo "docs/ directory is empty"
    fi
else
    echo ""
    echo "ERROR: HTML report generation failed"
    exit 1
fi

