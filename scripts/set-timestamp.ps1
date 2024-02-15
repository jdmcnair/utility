param (
	[Parameter(Mandatory=$true)][string]$filename,
	[Datetime]$timestamp = (Get-Date)
)


$(Get-Item $filename).creationtime=$timestamp
$(Get-Item $filename).lastaccesstime=$timestamp
$(Get-Item $filename).lastwritetime=$timestamp

("Set CreationTime, LastAccessTime, LastWriteTime for: " + $filename + " to: " + $timestamp)