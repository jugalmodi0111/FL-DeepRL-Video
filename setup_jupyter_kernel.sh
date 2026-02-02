#!/bin/bash

# ============================================================================
# Jupyter Kernel Setup Script
# ============================================================================
# Purpose: Automatically configure Python 3.14 kernel for Jupyter notebooks
# ============================================================================

echo "=========================================="
echo "  JUPYTER KERNEL SETUP"
echo "=========================================="
echo ""

# Find Python executable
PYTHON_PATH="/opt/homebrew/bin/python3"

if [ ! -f "$PYTHON_PATH" ]; then
    echo "❌ Python not found at $PYTHON_PATH"
    echo "🔍 Searching for Python..."
    PYTHON_PATH=$(which python3)
    if [ -z "$PYTHON_PATH" ]; then
        echo "❌ No Python 3 found. Please install Python first."
        exit 1
    fi
fi

echo "✅ Found Python: $PYTHON_PATH"
PYTHON_VERSION=$($PYTHON_PATH --version)
echo "📌 Version: $PYTHON_VERSION"
echo ""

# Step 1: Install Jupyter and IPyKernel
echo "📦 Step 1: Installing Jupyter and IPyKernel..."
echo "   (This may take 1-2 minutes...)"
$PYTHON_PATH -m pip install --user --upgrade pip setuptools wheel
$PYTHON_PATH -m pip install --user jupyter ipykernel notebook

if [ $? -ne 0 ]; then
    echo "❌ Failed to install Jupyter packages"
    exit 1
fi

echo "✅ Jupyter packages installed"
echo ""

# Step 2: Register the kernel
echo "📝 Step 2: Registering Python kernel with Jupyter..."
$PYTHON_PATH -m ipykernel install --user --name python3-fl --display-name "Python 3 (FL with HE)"

if [ $? -ne 0 ]; then
    echo "❌ Failed to register kernel"
    exit 1
fi

echo "✅ Kernel registered"
echo ""

# Step 3: Verify installation
echo "🔍 Step 3: Verifying installation..."
echo ""
echo "Available Jupyter kernels:"
$PYTHON_PATH -m jupyter kernelspec list

echo ""
echo "=========================================="
echo "  ✅ SETUP COMPLETE!"
echo "=========================================="
echo ""
echo "📋 Next Steps:"
echo "   1. Close VS Code completely"
echo "   2. Reopen VS Code"
echo "   3. Open your notebook"
echo "   4. Click kernel selector (top-right)"
echo "   5. Select: 'Python 3 (FL with HE)'"
echo ""
echo "🎉 Your notebook will now use Python 3.14!"
echo "=========================================="
