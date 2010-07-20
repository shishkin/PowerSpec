remove-module PowerSpec -ea SilentlyContinue
import-module .\PowerSpec.psm1

resolve-path ".\specs\*.ps1" | test-spec | out-null

remove-module PowerSpec