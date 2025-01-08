# Define color variables
Red="\033[0;31m"
Green="\033[0;32m"
Blue="\033[0;34m"
NC="\033[0m" # No Color

# validate linting of the code before commit.
echo -e "\n${Blue}=================================${NC}\n"

echo -e "${Green}Start - Linting of the code.${NC}"

# Run each command and capture its exit code
make lint-fix
lint_exit=$?

make formatter-fix
fmt_exit=$?

make additional-checks-fix
vet_exit=$?

# Check if any command failed
if [ $lint_exit -ne 0 ] || [ $fmt_exit -ne 0 ] || [ $vet_exit -ne 0 ]; then
    echo -e "${Red}Linting failed!${NC}"
    exit 1
fi

git add .

echo -e "${Green}End - Linting of the code.${NC}"

echo -e "\n${Blue}=================================${NC}\n"

# Exit with the captured exit code
exit $exit_code