#Requires -RunAsAdministrator

param (
	[Parameter(Mandatory = $true)]
	[ValidateSet('start', 'stop')]
	[string]
	$action,
	[Parameter(Mandatory = $true)]
	[ValidateSet('all', 'mongo', 'oracle', 'postgres', 'mssql')]
	[string]
	$database
)

$mongoServices = @('mongodb')
$oracleServices = @('OracleServiceXE', 'OracleXETNSListener')
$sqlServerExpressServices = @('MSSQL$SQLEXPRESS', 'SQLTELEMETRY$SQLEXPRESS', 'SQLWriter')
$sqlServerServices = @('MSSQLSERVER', 'SQLWriter')
$postgresServices = @('postgresql-x64-14') #, 'pgagent-pg14')
$allServices = $mongoServices + $oracleServices + $postgresServices # + $sqlServerExpressServices + $sqlServerServices

switch ($database) {
	'all' { $list = $allServices }
	'mongo' { $list = $mongoServices }
	'oracle' { $list = $oracleServices }
	'postgres' { $list = $postgresServices }
	'mssql' { $list = $sqlServerServices }
	'msexpress' { $list = $sqlServerExpressServices }
	default { throw "Bad database specification" }
}

function actOnServices {
	if ($action -eq 'start') {
		Foreach ($service in $list) {
			Write-Host "Starting: " $service
			Start-Service -name $service
		}
	}
 else {
		Foreach ($service in $list) {
			Write-Host "Stopping: " $service
			Stop-Service -name $service
		}
	}
}


actOnServices
