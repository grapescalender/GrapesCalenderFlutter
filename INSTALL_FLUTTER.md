# 🚀 Flutter Installation Guide for macOS

## Option 1: Install Flutter Using Homebrew (EASIEST ⭐)

```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Flutter via Homebrew
brew install flutter

# Verify installation
flutter --version
```

---

## Option 2: Manual Installation (More Control)

### Step 1: Download Flutter SDK
```bash
# Create a directory for Flutter
mkdir -p ~/development
cd ~/development

# Download Flutter (this is ~600MB, takes a few minutes)
git clone https://github.com/flutter/flutter.git -b stable
```

### Step 2: Add Flutter to PATH
```bash
# Open your shell profile (zsh for macOS)
nano ~/.zshrc

# Add this line at the end:
export PATH="$PATH:$HOME/development/flutter/bin"

# Save and exit (Ctrl+X, then Y, then Enter)

# Reload your shell
source ~/.zshrc

# Verify
flutter --version
```

---

## Option 3: Using FVM (Flutter Version Manager - RECOMMENDED)

```bash
# Install FVM via Homebrew
brew install fvm

# Install Flutter stable version
fvm install stable

# Set as global
fvm global stable

# Verify
fvm flutter --version
```

---

## After Installing Flutter

### Step 1: Accept Android Licenses
```bash
flutter doctor --android-licenses
# Press 'y' for all prompts
```

### Step 2: Check Installation
```bash
flutter doctor
```

You should see:
```
✓ Flutter
✓ Android toolchain
✓ Xcode (for iOS)
```

### Step 3: Install Required Tools
```bash
# For iOS development (macOS only)
flutter pub global activate xcode_install

# For Android emulator
# Use Android Studio to download
```

---

## Then Run Your App

Once Flutter is installed, run:

```bash
cd /Users/swapnil/Desktop/FlutterAppGrapes

# Step 1: Clean
flutter clean

# Step 2: Get dependencies
flutter pub get

# Step 3: Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Step 4: Run app
flutter run
```

---

## If You Already Have Flutter Installed Elsewhere

Find it:
```bash
find ~ -name "flutter" -type d 2>/dev/null
```

Then add to PATH in `~/.zshrc`:
```bash
export PATH="$PATH:/path/to/your/flutter/bin"
```

Then reload:
```bash
source ~/.zshrc
```

---

## Troubleshooting

### "zsh: command not found: flutter"
- Flutter is not in your PATH
- Solution: See "Add Flutter to PATH" section above
- Restart terminal after editing ~/.zshrc

### "Flutter not installed"
- Use Homebrew: `brew install flutter`
- Or download manually from flutter.dev

### "Android licenses not accepted"
- Run: `flutter doctor --android-licenses`

### "Xcode not installed" (iOS development)
- Run: `xcode-select --install`

---

## Quick Command Reference

```bash
# Check Flutter version
flutter --version

# Check doctor status
flutter doctor

# Accept licenses
flutter doctor --android-licenses

# List devices
flutter devices

# Clean project
flutter clean

# Get dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Run on specific device
flutter run -d <device_id>
```

---

## Need Help?

1. **Official Guide**: https://flutter.dev/docs/get-started/install/macos
2. **YouTube**: Search "Flutter installation macOS"
3. **Discord**: https://discord.gg/flutter

---

**Once Flutter is installed and in your PATH, come back and run:**
```bash
cd /Users/swapnil/Desktop/FlutterAppGrapes && flutter pub get
```
