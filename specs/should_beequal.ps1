3 | should-beEqual -to 3

# Script blocks can be used to aid test feedback
{ 10 * 5 } | should-beEqual -to 50

should-throw { 3 | should-beEqual -to 4 }