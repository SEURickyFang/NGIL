$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path.TrimEnd('\')
$allowed = @(
    '.gitignore',
    'README.md',
    'docs/interface.md',
    'examples/generate_synthetic_data.m',
    'examples/plot_synthetic_data.m',
    'examples/summarize_synthetic_episode.m',
    'examples/synthetic_episode.csv',
    'tools/audit_release.ps1',
    'assets/framework.png'
)
$blocked = @('.mat', '.p', '.slx', '.slxc', '.cpar', '.sim', '.par', '.mexw64', '.dll')
$unexpected = @(
    Get-ChildItem -LiteralPath $root -Recurse -Force -File |
        Where-Object { -not $_.FullName.StartsWith($root + '\.git\', [StringComparison]::OrdinalIgnoreCase) } |
        ForEach-Object {
            $rel = $_.FullName.Substring($root.Length).TrimStart('\').Replace('\', '/')
            $isAnimation = $rel.StartsWith('assets/animations/') -and $_.Extension -eq '.gif'
            if ($_.Extension.ToLowerInvariant() -in $blocked -or ($rel -notin $allowed -and -not $isAnimation)) {
                $rel
            }
        }
)
if ($unexpected.Count -gt 0) {
    $unexpected | Sort-Object | ForEach-Object { Write-Error "Unexpected or blocked file: $_" }
    exit 1
}
Write-Output 'Public release audit passed: no unexpected files found.'
