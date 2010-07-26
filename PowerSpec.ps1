$base_dir = split-path $MyInvocation.InvocationName

resolve-path "$base_dir\PowerSpec*.psm1" | import-module -force

resolve-path ".\specs\*.ps1" | test-spec | out-null

get-module "PowerSpec*" | remove-module