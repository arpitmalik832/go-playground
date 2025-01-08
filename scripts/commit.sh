# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Installing gum..."
    brew install gum || {
        echo -e "${RED}Failed to install gum. Please install it manually:${NC}"
        echo "brew install gum"
        exit 1
    }
fi

# Available options
TYPES=("bump" "chore" "docs" "e2e" "feat" "fix" "optimize" "refactor" "revamp" "revert" "security" "style" "test")
SCOPES=("assets" "components" "atoms" "molecules" "organisms" "configs" "contexts" "enums" "hooks" "pages" "queries" "routes" "services" "utils" "main")

# Print header
echo -e "\n${BLUE}=== Interactive Commit Menu ===${NC}\n"

# 1. Select type
echo -e "${GREEN}Select commit type:${NC}"
type=$(gum choose "${TYPES[@]}")
[ -z "$type" ] && exit 1

# 2. Select scope
echo -e "\n${GREEN}Select commit scope:${NC}"
scope=$(gum choose "${SCOPES[@]}")
[ -z "$scope" ] && exit 1

# 3. Enter description
echo -e "\n${GREEN}Select commit description:${NC}"
description=$(gum input --placeholder "Enter commit description")
[ -z "$description" ] && exit 1

# 4. Enter body (optional)
echo -e "\n${GREEN}Select commit body (optional):${NC}"
body=$(gum write --placeholder "Enter commit body (optional, press Ctrl+D when done)")

# 5. Breaking change?
echo -e "\n${GREEN}Is this a breaking change:${NC}"
breaking=$(gum confirm "Is this a breaking change?" && echo "true" || echo "false")

# Build commit message
message="$type($scope): $description"

if [ -n "$body" ]; then
    message="$message\n\n$body"
fi

if [ "$breaking" = "true" ]; then
    message="$message\n\nBREAKING CHANGE: Yes"
fi

# Show preview
echo -e "\n${BLUE}=== Commit Preview ===${NC}"
echo -e "${GREEN}$message${NC}"
echo -e "\n${BLUE}=====================${NC}\n"

# Confirm
gum confirm "Proceed with commit?" && git commit -m "$message" || {
    echo -e "${RED}Commit aborted${NC}"
    exit 1
} 