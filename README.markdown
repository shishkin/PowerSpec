PowerSpec 0.0.4
====

PowerSpec is a PowerShell module aimed to aid Test-Driven Development with PowerShell.

Example
----

 - Create a subfolder named 'specs' under your project folder
 - Create a PS script file '.\specs\some_filename.ps1' with the following content:

		{ 10 * 5 } | should be_equal 60
		
		{ shit happens } | should throw
		
		{ 1 + 2 } | should not throw

 - Run .\..\Any\Path\To\PowerSpec\powerspec.cmd from your project folder
 - Enjoy your colorful test results:

		some_filename.ps1
			10 * 5  should be equal 60 FAILED
			shit happens should throw PASSED
			1 + 2 should not throw PASSED
		Test results: 1 failed, 2 passed, 3 total.

Usage From PowerShell
----

It is also possible to import the PowerSpec module into PowerShell session and write specifications inline:

		> import-module .\PowerSpec.psm1 -force
		> test-spec { { 1 + 2 } | should not throw }
