$base_dir = split-path $MyInvocation.InvocationName

"$base_dir\PowerSpec.psm1" | import-module -force

test-spec @args | out-null
