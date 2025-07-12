cd /Users/davidmorrison/Sites2/Production/freddie-mac/freddie-mac-demo

# First, let's see what the differences are
git diff --cached .gitignore  # Shows staged changes
git diff .gitignore           # Shows unstaged changes

# Commit the current staged changes
git commit -m "Remove unnecessary openrisk_navigator.backup pattern from .gitignore"

# Then add the remaining changes
git add .gitignore
git commit -m "Final .gitignore cleanup"


# Check if git thinks these files were deleted from tracking
git ls-files --deleted | grep openrisk_navigator

# Check if the files are in git's index at all
git ls-files development/drupal-site/web/modules/custom/openrisk_navigator/
git ls-files production/drupal-site/web/modules/custom/openrisk_navigator/

# If the above shows nothing, the files aren't tracked. Check if they're being ignored:
git check-ignore development/drupal-site/web/modules/custom/openrisk_navigator/openrisk_navigator.info.yml

# Force git to see the files (this should work now with clean .gitignore)
git add -f development/drupal-site/web/modules/custom/openrisk_navigator/
git add -f production/drupal-site/web/modules/custom/openrisk_navigator/

# Check status after force add
git status



