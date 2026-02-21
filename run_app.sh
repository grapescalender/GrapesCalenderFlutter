#!/bin/bash

# 🍇 DRAKSHSETU - APP RUN SCRIPT
# Setup and run your Flutter app

set -e  # Exit on any error

echo ""
echo "════════════════════════════════════════════════"
echo "   🍇 DRAKSHSETU - GRAPE FARM APP 🍇"
echo "════════════════════════════════════════════════"
echo ""

# Change to project directory
cd "$(dirname "$0")"

echo "📍 Project Location: $(pwd)"
echo ""

# Step 1: Check Flutter installation
echo "🔍 Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found in PATH"
    echo ""
    echo "📝 To install Flutter, visit: https://flutter.dev/docs/get-started/install"
    echo ""
    echo "After installation, add Flutter to your PATH:"
    echo "  export PATH=\"\$PATH:/path/to/flutter/bin\""
    echo ""
    echo "Then restart your terminal and run this script again."
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Step 2: Check device connection
echo "📱 Checking for connected devices..."
DEVICES=$(flutter devices 2>/dev/null | grep -v "^$" | wc -l)
if [ "$DEVICES" -lt 2 ]; then
    echo "⚠️  No device or emulator found"
    echo ""
    echo "Options:"
    echo "  1. Connect a physical Android/iOS device"
    echo "  2. Start an Android emulator (Android Studio > AVD Manager)"
    echo "  3. Start iOS simulator (open -a Simulator)"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""

# Step 3: Clean
echo "🧹 Step 1/4: Cleaning project..."
flutter clean

echo ""

# Step 4: Get dependencies
echo "📦 Step 2/4: Installing dependencies..."
flutter pub get

echo ""

# Step 5: Generate code
echo "🔨 Step 3/4: Generating code (Freezed models, JSON, etc.)..."
echo "   ⏳ This may take 30-60 seconds on first run..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""

# Step 6: Run app
echo "▶️ Step 4/4: Launching app..."
echo ""
flutter run

echo ""
echo "════════════════════════════════════════════════"
echo "✅ Setup complete! App is running..."
echo "════════════════════════════════════════════════"
echo ""
