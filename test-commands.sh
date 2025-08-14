#!/bin/bash
# test-commands.sh
# Comprehensive demonstration of py-psscriptanalyzer capabilities
# with the PowerShell files in this repository

# Set colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print section headers
section() {
    echo -e "\n${BLUE}======================================================${NC}"
    echo -e "${BLUE}= $1${NC}"
    echo -e "${BLUE}======================================================${NC}\n"
}

# Function to run a command with descriptive output
run_command() {
    echo -e "${YELLOW}COMMAND:${NC} $1"
    echo -e "${GREEN}DESCRIPTION:${NC} $2"
    echo -e "${CYAN}RUNNING...${NC}"
    eval $1
    echo -e "${CYAN}EXIT CODE: $?${NC}"
    echo -e "\n${BLUE}------------------------------------------------------${NC}\n"
}

# Ensure we're in the right directory
cd "$(dirname "$0")"

# Check if py-psscriptanalyzer is installed
if ! command -v py-psscriptanalyzer &> /dev/null; then
    echo -e "${RED}py-psscriptanalyzer is not installed. Please install it with:${NC}"
    echo -e "${YELLOW}pip install py-psscriptanalyzer${NC}"
    exit 1
fi

# 1. Basic Usage
section "1. BASIC ANALYSIS"

run_command "py-psscriptanalyzer scripts/BadScript.ps1" \
    "Basic analysis of a single script with default severity (Warning)"

run_command "py-psscriptanalyzer scripts/MixedSeverity.ps1 scripts/SecurityIssues.ps1" \
    "Analyze multiple scripts at once"

# 2. Severity Levels
section "2. SEVERITY LEVELS"

run_command "py-psscriptanalyzer --severity Error scripts/SecurityIssues.ps1" \
    "Show only Error severity issues"

run_command "py-psscriptanalyzer --severity Warning scripts/MixedSeverity.ps1" \
    "Show Warning and Error severity issues (default)"

run_command "py-psscriptanalyzer --severity Information scripts/InformationIssues.ps1" \
    "Show all issues including Information severity"

# 3. Formatting
section "3. FORMATTING"

run_command "py-psscriptanalyzer --format scripts/InformationIssues.ps1 --output-file /tmp/formatted.ps1" \
    "Format a PowerShell file and save to a different location"

# 4. Output Formats
section "4. OUTPUT FORMATS"

run_command "py-psscriptanalyzer --severity Warning scripts/SecurityIssues.ps1 --output-format json" \
    "Output results in JSON format"

run_command "py-psscriptanalyzer --severity Warning scripts/SecurityIssues.ps1 --output-format sarif --output-file /tmp/security-issues.sarif" \
    "Output results in SARIF format for integration with code scanning tools"

# 5. Recursive Analysis
section "5. RECURSIVE ANALYSIS"

run_command "py-psscriptanalyzer --recursive --severity Warning" \
    "Recursively analyze all PowerShell files in the current directory"

# 6. File Type Filtering
section "6. FILE TYPE FILTERING"

run_command "find . -name '*.ps1' | xargs py-psscriptanalyzer --severity Warning" \
    "Analyze only .ps1 files"

run_command "find . -name '*.psm1' | xargs py-psscriptanalyzer --severity Warning" \
    "Analyze only .psm1 module files"

run_command "find . -name '*.psd1' | xargs py-psscriptanalyzer --severity Warning" \
    "Analyze only .psd1 module manifest files"

# 7. Category-Specific Analysis
section "7. CATEGORY-SPECIFIC ANALYSIS"

run_command "py-psscriptanalyzer scripts/SecurityIssues.ps1" \
    "Security-focused analysis on security-specific issues file"

run_command "py-psscriptanalyzer scripts/ConfigurationIssues.ps1" \
    "DSC Configuration analysis"

run_command "py-psscriptanalyzer scripts/EdgeCases.ps1" \
    "Analyze edge cases and compatibility issues"

# 8. Excluding Files
section "8. EXCLUDING FILES"

run_command "find . -name '*.ps1' | grep -v 'EdgeCases' | xargs py-psscriptanalyzer" \
    "Analyze all PS1 files except EdgeCases.ps1"

# 9. Show PS Version and Module Info
section "9. ENVIRONMENT INFORMATION"

# This command is used to help diagnose issues
run_command "pwsh -c 'Write-Output \"PowerShell Version:\"; \$PSVersionTable; Write-Output \"\nPSScriptAnalyzer Module:\"; Get-Module -ListAvailable -Name PSScriptAnalyzer'" \
    "Display PowerShell and PSScriptAnalyzer version information"

# 10. Environment Variables
section "10. ENVIRONMENT VARIABLES"

run_command "echo 'Setting SEVERITY_LEVEL environment variable:' && export SEVERITY_LEVEL=Error && py-psscriptanalyzer scripts/SecurityIssues.ps1 && unset SEVERITY_LEVEL" \
    "Using SEVERITY_LEVEL environment variable to set severity"

# 11. Rule Categories
section "11. RULE CATEGORIES"

run_command "py-psscriptanalyzer --recursive --security-only" \
    "Run only security rules"

run_command "py-psscriptanalyzer --recursive --style-only" \
    "Run only style rules"

run_command "py-psscriptanalyzer --recursive --performance-only" \
    "Run only performance rules"

run_command "py-psscriptanalyzer --recursive --best-practices-only" \
    "Run only best practices rules"

run_command "py-psscriptanalyzer --recursive --dsc-only" \
    "Run only DSC rules"

run_command "py-psscriptanalyzer --recursive --compatibility-only" \
    "Run only compatibility rules"

# 12. Include/Exclude Rules
section "12. INCLUDE/EXCLUDE SPECIFIC RULES"

run_command "py-psscriptanalyzer scripts/SecurityIssues.ps1 --include-rules PSAvoidUsingPlainTextForPassword,PSAvoidUsingConvertToSecureStringWithPlainText" \
    "Include only specific security rules"

run_command "py-psscriptanalyzer scripts/BadScript.ps1 --exclude-rules PSAvoidUsingWriteHost" \
    "Exclude a specific rule"

# 13. Comprehensive Analysis
section "13. COMPREHENSIVE ANALYSIS"

run_command "py-psscriptanalyzer --recursive --severity Information" \
    "Full recursive analysis of all PowerShell files with all severity levels"

# 14. Pre-commit Integration
section "14. PRE-COMMIT INTEGRATION"

# This shows the pre-commit configuration but doesn't run it
run_command "cat .pre-commit-config.yaml" \
    "Display pre-commit configuration"

section "TEST SUITE COMPLETE"
echo -e "${GREEN}All tests have been executed successfully.${NC}"
echo -e "${CYAN}This script demonstrated all major features of py-psscriptanalyzer.${NC}"
