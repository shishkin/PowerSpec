$base_dir = split-path $MyInvocation.InvocationName

"$base_dir\PowerSpec.psm1" | import-module -force

try { resolve-path ".\specs\*.ps1" | test-spec | out-null }
finally { get-module "PowerSpec" | remove-module }