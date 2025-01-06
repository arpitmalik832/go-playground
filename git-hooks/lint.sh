# Define color variables
Red="\033[0;31m"
Green="\033[0;32m"
Blue="\033[0;34m"
NC="\033[0m" # No Color

# validate linting of the code before commit.
echo -e "\n${Blue}=================================${NC}\n"

echo -e "${Green}Start - Linting of the code.${NC}"

# Format code
go fmt ./...

# Run golangci-lint with auto-fix
golangci-lint run --fix

# Run additional checks
go vet ./...

echo -e "${Green}End - Linting of the code.${NC}"

echo -e "\n${Blue}=================================${NC}\n"