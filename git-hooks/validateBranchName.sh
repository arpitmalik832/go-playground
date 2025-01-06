# Define color variables
Red="\033[0;31m"
Green="\033[0;32m"
Blue="\033[0;34m"
NC="\033[0m" # No Color

# Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# validate branch name before pushing.
echo -e "\n${Blue}=================================${NC}\n"

echo -e "${Green}Start - Validating branch name.${NC}"

# Define the pattern (customize as needed)
PATTERN="^(development|staging|beta|release|master|main){1}$|^((task|release|bugfix|hotfix)/|(feature-))[a-zA-Z0-9._-]+$|[a-zA-Z0-9._-]+$"

if [[ ! $BRANCH_NAME =~ $PATTERN ]]; then
    echo "Error: Branch name '$BRANCH_NAME' does not match the required pattern"
    echo "Pattern: $PATTERN"
    echo "Examples:"
    echo "  feature/add-login"
    echo "  fix/user-auth"
    echo "  chore/update-deps"
    exit 1
else
    echo -e "${GREEN}✓ Branch name '$BRANCH_NAME' is valid${NC}"
fi

echo -e "${Green}End - Validating branch name.${NC}"

echo -e "\n${Blue}=================================${NC}\n"
