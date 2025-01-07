# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Available types
TYPES=("bump" "chore" "docs" "e2e" "feat" "fix" "optimize" "refactor" "revamp" "revert" "security" "style" "test")
SCOPES=("assets" "components" "atoms" "molecules" "organisms" "configs" "contexts" "enums" "hooks" "pages" "queries" "routes" "services" "utils" "main")

# Print header
echo -e "\n${BLUE}=== Interactive Commit Menu ===${NC}\n"

# 1. Select type
echo -e "${GREEN}Select commit type:${NC}"
select type in "${TYPES[@]}"; do
    if [[ -n $type ]]; then
        break
    fi
    echo -e "${RED}Invalid selection${NC}"
done

# 2. Enter scope
echo -e "${GREEN}Select commit scope:${NC}"
select scope in "${SCOPES[@]}"; do
    if [[ -n $scope ]]; then
        break
    fi
    echo -e "${RED}Invalid selection${NC}"
done

# 3. Enter description
while true; do
    echo -e "\n${GREEN}Enter commit description:${NC}"
    read description
    if [[ -n $description ]]; then
        break
    fi
    echo -e "${RED}Description cannot be empty${NC}"
done

# 4. Enter body
echo -e "\n${GREEN}Enter commit body (optional, press enter to skip):${NC}"
read body

# 5. Is breaking change?
echo -e "\n${GREEN}Is this a breaking change? (Y/N):${NC}"
read breaking

# Build commit message
message="$type"
if [[ -n $scope ]]; then
    message="$message($scope)"
fi
message="$message: $description"

if [[ -n $body ]]; then
    message="$message\n\n$body"
fi

if [[ $breaking =~ ^[Yy]$ ]]; then
    message="$message\n\nBREAKING CHANGE: Yes"
fi

# Show preview
echo -e "\n${BLUE}=== Commit Preview ===${NC}"
echo -e "${GREEN}$message${NC}"
echo -e "\n${BLUE}=====================${NC}\n"

# Confirm
echo -e "${GREEN}Proceed with commit? (Y/N):${NC}"
read proceed
if [[ $proceed =~ ^[Nn]$ ]]; then
    echo -e "${RED}Commit aborted${NC}"
    exit 1
fi

# Commit
git commit -m "$message" 