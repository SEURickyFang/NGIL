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
    'assets/framework.png',
    'code/control/base_slip.m',
    'code/control/controller_sfun.m',
    'code/control/controller_step.p',
    'code/control/observation.m',
    'code/control/slip_reference.m',
    'code/control/steer_limit.m',
    'code/expert/build_nmpc.p',
    'code/expert/solve_nmpc.p',
    'code/learning/label_trajectory.m',
    'code/learning/mirror.m',
    'code/learning/predict_policy.p',
    'code/learning/train_member.p',
    'code/learning/train_policy.m',
    'code/models/vehicle_model.p',
    'code/parameters.p',
    'code/setup.m',
    'code/tests/test_slip_reference.m',
    'models/NGIL_Controller.slx'
)
$blocked = @('.mat', '.p', '.slx', '.slxc', '.cpar', '.sim', '.par', '.mexw64', '.dll')
$unexpected = @(
    Get-ChildItem -LiteralPath $root -Recurse -Force -File |
        Where-Object { -not $_.FullName.StartsWith($root + '\.git\', [StringComparison]::OrdinalIgnoreCase) } |
        ForEach-Object {
            $rel = $_.FullName.Substring($root.Length).TrimStart('\').Replace('\', '/')
            $isAnimation = $rel.StartsWith('assets/animations/') -and $_.Extension -eq '.gif'
            if (($rel -notin $allowed) -and (($_.Extension.ToLowerInvariant() -in $blocked) -or -not $isAnimation)) {
                $rel
            }
        }
)
if ($unexpected.Count -gt 0) {
    $unexpected | Sort-Object | ForEach-Object { Write-Error "Unexpected or blocked file: $_" }
    exit 1
}
Write-Output 'Public release audit passed: no unexpected files found.'
