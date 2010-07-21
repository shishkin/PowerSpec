$base_dir = split-path $MyInvocation.InvocationName

import-module "$base_dir\PowerSpec.psm1" -force

resolve-path ".\specs\*.ps1" | test-spec | out-null

remove-module PowerSpec