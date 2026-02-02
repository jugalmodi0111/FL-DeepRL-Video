#!/bin/bash

# ============================================================================
# Virtual Environment + Jupyter Kernel Setup Script
# ============================================================================
# Purpose: Create a virtual environment and configure it for Jupyter notebooks
# ============================================================================

echo "=========================================="
echo "  VIRTUAL ENVIRONMENT SETUP"
echo "=========================================="
echo ""

VENV_PATH=".venv"
PYTHON_PATH="/opt/homebrew/bin/python3"

# Step 1: Create virtual environment
echo "📦 Step 1: Creating virtual environment..."
if [ -d "$VENV_PATH" ]; then
    echo "⚠️  Virtual environment already exists at $VENV_PATH"
    read -p "   Delete and recreate? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$VENV_PATH"
        echo "🗑️  Deleted old environment"
    else
        echo "📝 Using existing environment"
    fi
fi

if [ ! -d "$VENV_PATH" ]; then
    $PYTHON_PATH -m venv "$VENV_PATH"
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create virtual environment"
        exit 1
    fi
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment ready"
fi

echo ""

# Step 2: Activate and install packages
echo "📦 Step 2: Installing Jupyter and dependencies..."
source "$VENV_PATH/bin/activate"

# Upgrade pip first
python -m pip install --upgrade pip setuptools wheel

# Install Jupyter
python -m pip install jupyter ipykernel notebook

# Install ML packages
echo ""
echo "📦 Installing ML packages (this takes 2-3 minutes)..."
python -m pip install torch torchvision stable-baselines3[extra] gymnasium numpy pandas matplotlib seaborn scikit-learn opencv-python tqdm

if [ $? -ne 0 ]; then
    echo "❌ Failed to install packages"
    exit 1
fi

echo "✅ All packages installed"
echo ""

# Step 3: Register kernel
echo "📝 Step 3: Registering Jupyter kernel..."
python -m ipykernel install --user --name fl-with-he --display-name "Python 3 (FL with HE)"

if [ $? -ne 0 ]; then
    echo "❌ Failed to register kernel"
    exit 1
fi

echo "✅ Kernel registered"
echo ""

# Step 4: Verify
echo "🔍 Step 4: Verifying installation..."
echo ""
python --version
echo ""
python -c "import torch; print(f'PyTorch: {torch.__version__}')"
python -c "import stable_baselines3; print(f'Stable-Baselines3: {stable_baselines3.__version__}')"
python -c "import gymnasium; print(f'Gymnasium: {gymnasium.__version__}')"

echo ""
echo "Available Jupyter kernels:"
python -m jupyter kernelspec list

echo ""
echo "=========================================="
echo "  ✅ SETUP COMPLETE!"
echo "=========================================="
echo ""
echo "📋 Next Steps:"
echo "   1. In VS Code, click the kernel selector (top-right of notebook)"
echo "   2. Select: 'Python 3 (FL with HE)'"
echo "   3. If you don't see it, click 'Reload Window' (Cmd+R)"
echo ""
echo "🎯 Your notebook will now have:"
echo "   ✅ Python 3.14"
echo "   ✅ PyTorch"
echo "   ✅ Stable-Baselines3"
echo "   ✅ Gymnasium"
echo "   ✅ All required ML packages"
echo ""
echo "💡 To use this environment in terminal:"
echo "   source .venv/bin/activate"
echo "=========================================="

deactivate
