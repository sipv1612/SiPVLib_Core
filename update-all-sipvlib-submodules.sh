#!/bin/bash

# ---------------------------------------------------------------------
# update-all-sipvlib-submodules.sh
#
# Updates ALL submodules in Packages/ matching prefix "com.sipvlib."
# 1. Pulls latest for each submodule
# 2. Stages updated pointers in parent repo
# 3. Commits & pushes parent repo
#
# ---------------------------------------------------------------------

# Config
SUBMODULE_ROOT="Packages"
SUBMODULE_PREFIX="com.sipvlib."
PARENT_BRANCH="main"
SUBMODULE_BRANCH="main"

echo "🔍 Finding submodules in $SUBMODULE_ROOT with prefix '$SUBMODULE_PREFIX'..."

# Find all matching submodules
SUBMODULES=$(find "$SUBMODULE_ROOT" -maxdepth 1 -type d -name "${SUBMODULE_PREFIX}*")

if [ -z "$SUBMODULES" ]; then
  echo "❌ No submodules found with prefix '$SUBMODULE_PREFIX'!"
  exit 1
fi

echo "✅ Found submodules:"
echo "$SUBMODULES"

echo ""

for SUBMODULE in $SUBMODULES; do
  echo "🔄 Updating submodule: $SUBMODULE"

  # Go into submodule and pull latest
  cd "$SUBMODULE" || { echo "❌ Could not enter $SUBMODULE"; exit 1; }
  git pull origin "$SUBMODULE_BRANCH"

  # Go back to root
  cd - >/dev/null
done

echo "📝 Staging updated submodule pointers..."
git add $SUBMODULES

echo "🗂️  Committing..."
git commit -m "Update all sipvlib submodules to latest $SUBMODULE_BRANCH"

echo "🚀 Pushing parent repo..."
git push origin "$PARENT_BRANCH"

echo "✅ Done. All sipvlib submodules updated & parent pushed!"
