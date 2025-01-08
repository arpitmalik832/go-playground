# Define color variables
Red="\033[0;31m"
Green="\033[0;32m"
Blue="\033[0;34m"
NC="\033[0m" # No Color

# validate linting of the code before commit.
echo -e "\n${Blue}=================================${NC}\n"

echo -e "${Green}Start - Unit testing of the Code.${NC}"

make test-coverage-check
exit_code=$?

# Check if the command failed
if [ $exit_code -ne 0 ]; then
    echo -e "${Red}Test coverage check failed!${NC}"
    echo -e "${Red}Coverage must be at least 90%${NC}"
fi

echo -e "${Green}End - Unit testing of the Code.${NC}"

echo -e "\n${Blue}=================================${NC}\n"

# Exit with the captured exit code
exit $exit_code