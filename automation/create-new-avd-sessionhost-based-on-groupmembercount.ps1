try {
    Connect-AzAccount -Identity

    $storageAccountKey = Get-AutomationVariable -Name 'storageAccountKey' -ErrorAction Stop
    $storageAccountName = Get-AutomationVariable -Name 'storageAccountName' -ErrorAction Stop
    $storageAccountContainer = Get-AutomationVariable -Name 'storageAccountContainer' -ErrorAction Stop

    $armTemplateFileName = 'template.json'
    $parametersfileName = 'parameters.json'
    $modifiedparametersfileName = 'modified-parameters.json'
    $tempFolder = 'c:\temp'
    $armTemplateFileLocalPath = Join-Path -Path $tempFolder -ChildPath $armTemplateFileName
    $parametersFileLocalPath = Join-Path -Path $tempFolder -ChildPath $parametersfileName
    $modifiedParametersFileLocalPath = Join-Path -Path $tempFolder -ChildPath $modifiedparametersfileName

    $directoryContent = get-childitem $tempFolder\*.json
    write-output "start: $directoryContent"

    Remove-Item "$armTemplateFileLocalPath", "$parametersFileLocalPath", "$modifiedParametersFileLocalPath" -Recurse -Force -ErrorAction SilentlyContinue
    $directoryContent = get-childitem $tempFolder\*.json
    write-output "after remove-item: $directoryContent"

    $Context = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount -ErrorAction Stop

    write-output "Try downloading blob file `"$armTemplateFileName`" to `"$armTemplateFileLocalPath`""
    $null = Get-AzStorageBlobContent -Container $storageAccountContainer -Blob $armTemplateFileName -Destination $tempFolder -Force -Context $Context -ErrorAction Stop
    write-output "`"$armTemplateFileName`" downloaded successfully"

    write-output "Try downloading blob file `"$parametersFileLocalPath`" to `"$parametersFileLocalPath`""
    $null = Get-AzStorageBlobContent -Container $storageAccountContainer -Blob $parametersfileName -Destination $tempFolder -Force -Context $Context -ErrorAction Stop
    write-output "`"$parametersFileLocalPath`" downloaded successfully"
    
    $directoryContent = get-childitem $tempFolder\*.json

    write-output "after copy: $directoryContent"
    write-output "content: $(Get-Content $armTemplateFileLocalPath -ErrorAction Stop)"
    write-output "content: $(Get-Content $parametersFileLocalPath -ErrorAction Stop)"

    Remove-Item "$armTemplateFileLocalPath", "$parametersFileLocalPath", "$modifiedParametersFileLocalPath" -Recurse -Force -ErrorAction SilentlyContinue

    $directoryContent = get-childitem $tempFolder\*.json
    write-output "end: $directoryContent"
}
catch {
    Remove-Item "$armTemplateFileLocalPath", "$parametersFileLocalPath", "$modifiedParametersFileLocalPath" -Recurse -Force -ErrorAction SilentlyContinue
    write-output "failed to complete the job, check error logs."
    Write-Error -Message 'Something went wrong!!'
}

