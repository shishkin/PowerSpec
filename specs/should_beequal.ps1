3 | should be_equal 3

# Script blocks can be used to aid test feedback
{ 10 * 5 } | should be_equal 50

# Enum support:

{ [ConsoleKey]'A' } | should be_equal A

{ [ConsoleKey]'A' } | should be_equal 0x41
