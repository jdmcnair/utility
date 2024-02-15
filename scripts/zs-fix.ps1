#Requires -RunAsAdministrator

$task = Get-ScheduledTask -TaskName ZPA-Monitor -TaskPath \
$taskTrigger = $task.Triggers[0]

Write-Host "Current trigger repetition setting:"
Write-Host ($taskTrigger.Repetition | Format-Table | Out-String)

$taskTrigger.Repetition.Duration = $null
$taskTrigger.Repetition.Interval = $null

Write-Host "New trigger repetition setting:"
Write-Host ($taskTrigger.Repetition | Format-Table | Out-String)

$task = Set-ScheduledTask -TaskName ZPA-Monitor -TaskPath \ -Trigger $taskTrigger

Write-Host "Task repetition settings updated"