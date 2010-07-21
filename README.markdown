PowerSpec 0.0.1
====

PowerSpec is a PowerShell module aimed to aid Test-Driven Development with PowerShell.

Example
----

 - Create a subfolder named 'specs' under your project folder
 - Create a PS script file '.\specs\some_filename.ps1' with the following content:

	{ 10 * 5 } | should-beEqual -to 60

 - Run .\..\Any\Path\To\PowerSpec\powerspec.cmd from your project folder
 - Enjoy your colorful test results:

	some_filename.ps1 FAILED
	{ 10 * 5 } is not equal to 60.
	C:\serega\Code\PowerSpec\specs\some_filename.ps1 Ln 1 Col 2
	
	Test results: 1 failed, 1 Total.
