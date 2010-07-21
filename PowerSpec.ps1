import-module .\PowerSpec.psm1 -force

resolve-path ".\specs\*.ps1" | test-spec | out-null

remove-module PowerSpec