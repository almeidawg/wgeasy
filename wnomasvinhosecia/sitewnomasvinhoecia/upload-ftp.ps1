# FTP Upload Script for Wno Mas
# Upload to wnomas.wgalmeida.com.br

$ftpServer = "ftp://147.93.151.130"
$ftpUser = "u968231423.wnomas.wmeida.com.br"
$ftpPass = "130300@`$Wg"
$localPath = "C:\Users\Atendimento\Documents\01VISUALSTUDIO_OFICIAL\wnomasvinhosecia\sitewnomasvinhoecia\dist"
$remotePath = "/public_html"

# Load .NET assembly for FTP
Add-Type -AssemblyName System.Net

function Upload-FTPFile {
    param (
        [string]$localFile,
        [string]$remoteFile
    )

    try {
        $ftpUri = "$ftpServer$remoteFile"
        $ftp = [System.Net.FtpWebRequest]::Create($ftpUri)
        $ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $ftp.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)
        $ftp.UseBinary = $true
        $ftp.UsePassive = $true

        $content = [System.IO.File]::ReadAllBytes($localFile)
        $ftp.ContentLength = $content.Length

        $stream = $ftp.GetRequestStream()
        $stream.Write($content, 0, $content.Length)
        $stream.Close()

        Write-Host "Uploaded: $remoteFile" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error uploading $remoteFile : $_" -ForegroundColor Red
        return $false
    }
}

function Create-FTPDirectory {
    param (
        [string]$remoteDir
    )

    try {
        $ftpUri = "$ftpServer$remoteDir"
        $ftp = [System.Net.FtpWebRequest]::Create($ftpUri)
        $ftp.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
        $ftp.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)
        $ftp.UsePassive = $true

        $response = $ftp.GetResponse()
        $response.Close()
        Write-Host "Created directory: $remoteDir" -ForegroundColor Cyan
    }
    catch {
        # Directory might already exist
    }
}

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "  Wno Mas - FTP Upload" -ForegroundColor Yellow
Write-Host "  Uploading to: wnomas.wgalmeida.com.br" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

# Create directories first
Create-FTPDirectory "$remotePath/assets"
Create-FTPDirectory "$remotePath/wines"

# Get all files from dist
$files = Get-ChildItem -Path $localPath -Recurse -File

$total = $files.Count
$current = 0

foreach ($file in $files) {
    $current++
    $relativePath = $file.FullName.Substring($localPath.Length).Replace("\", "/")
    $remoteFilePath = "$remotePath$relativePath"

    Write-Host "[$current/$total] " -NoNewline
    Upload-FTPFile -localFile $file.FullName -remoteFile $remoteFilePath
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Upload Complete!" -ForegroundColor Green
Write-Host "  Site: https://wnomas.wgalmeida.com.br" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
