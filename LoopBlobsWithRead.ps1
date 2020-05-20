$blobsCount = 20
$today = Get-Date
For ($i=0; $i -le 20; $i++) {
	$blobPrefix = [string]::format("blob-{0}-{1:D2}-{2:D2}-{3:D2}:{4:D2}_{5:X8}-", $today.Year, $today.Month, $today.Day, $today.Minute, $today.Hour, $i)
	Write-output "`r`nGoing to upload and read back $blobsCount blobs with prefix $blobPrefix."
	cmd /c "dotnet run --project ./storage-blob-dotnet-latency-profiler/storage-blob-dotnet-latency-profiler.csproj testcontainer connstring results.csv prod true PutRandomSizeBlobTest $blobPrefix $blobsCount 268435456 100 99"
    cmd /c "dotnet run --project ./storage-blob-dotnet-latency-profiler/storage-blob-dotnet-latency-profiler.csproj testcontainer connstring results.csv prod true DataValidationSequenceTest $blobPrefix $blobsCount 268435456 100 100 99"
	if ($LASTEXITCODE -eq 10) { 
		Write-output "Error during blob read for $blobPrefix"
		exit 
	}
	Write-output "`r`nFinished uploading and validation of $blobsCount blobs with prefix $blobPrefix.`r`n"
}