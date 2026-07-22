# render-pptx.ps1
# Renders a .pptx file to a folder of PNG images (one per slide) using PowerPoint COM.
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File render-pptx.ps1 -pptxPath "path\to\file.pptx" -outDir "path\to\output"
#
# Outputs: slide1.png, slide2.png, ... in $outDir

param(
    [Parameter(Mandatory=$true)]
    [string]$pptxPath,

    [Parameter(Mandatory=$true)]
    [string]$outDir
)

$pptxPath = (Resolve-Path $pptxPath).Path
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}
$outDir = (Resolve-Path $outDir).Path

Write-Host "Rendering: $pptxPath"
Write-Host "Output:    $outDir"

$ppt = New-Object -ComObject PowerPoint.Application
$ppt.Visible = 1

try {
    $pres = $ppt.Presentations.Open($pptxPath, $false, $false, $true)
    $n = $pres.Slides.Count
    Write-Host "$n slides found."

    for ($i = 1; $i -le $n; $i++) {
        $out = Join-Path $outDir "slide$i.png"
        $pres.Slides.Item($i).Export($out, "PNG", 1920, 1080)
        Write-Host "  Rendered slide $i -> $out"
    }

    $pres.Close()
    Write-Host "Done. $n slides rendered to: $outDir"
} finally {
    $ppt.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ppt) | Out-Null
}
