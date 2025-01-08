# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Define validate_length function first
validate_length() {
	local input="$1"
	local max_length="$2"
	if [ ${#input} -gt $max_length ]; then
		return 1
	fi
	return 0
}

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

# Build commit message parts separately
header="$type($scope): $description"

# Validate header length
if ! validate_length "$header" 50; then
	echo -e "${RED}Commit message too long (max 50 chars). Please try again.${NC}"
	exit 1
fi

# Show preview
echo -e "\n${BLUE}=== Commit Preview ===${NC}"
echo -e "\n${GREEN}$header${NC}"
if [ -n "$body" ]; then
	echo -e "\n${GREEN}$body${NC}"
fi
if [ "$breaking" = "true" ]; then
	echo -e "\n${GREEN}BREAKING CHANGE: Yes${NC}"
fi
echo -e "\n${BLUE}=====================${NC}\n"

# Commit with proper message formatting
makeCommit () {
	if [ "$breaking" = "true" ]; then
		if [ -n "$body" ]; then
			git commit -m "$header" -m "$body" -m "BREAKING CHANGE: Yes"
		else
			git commit -m "$header" -m "BREAKING CHANGE: Yes"
		fi
	else
		if [ -n "$body" ]; then
			git commit -m "$header" -m "$body"
		else
			git commit -m "$header"
		fi
	fi || {
		echo -e "${RED}Commit aborted${NC}"
		exit 1
	}
}


# Confirm
gum confirm "Proceed with commit?" && makeCommit || {
	echo -e "${RED}Commit aborted${NC}"
	exit 1
}