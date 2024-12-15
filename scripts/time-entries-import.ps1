Set-Location C:\code\sustaining-utilities\Python\
conda activate salesforce
python import-processed.py
if ($LASTEXITCODE -ne 0) {
    Write-Error "Python script failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}
