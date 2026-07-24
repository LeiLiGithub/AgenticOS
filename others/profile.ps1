# ==============================
# Modules
# ==============================

Import-Module PSReadLine -ErrorAction SilentlyContinue
Import-Module posh-git -ErrorAction SilentlyContinue

# 关闭 Git 文件状态扫描，只保留分支显示，避免大仓库卡顿
if ($global:GitPromptSettings) {
    $GitPromptSettings.EnableFileStatus = $false
}


# ==============================
# Conda initialize
# ==============================

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "D:\Software\miniforge3\Scripts\conda.exe") {
    (& "D:\Software\miniforge3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion


# ==============================
# PSReadLine: bash-like shortcuts
# ==============================

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

Set-PSReadLineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function EndOfLine

Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardChar
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardChar

Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextHistory

Set-PSReadLineKeyHandler -Chord Ctrl+k -Function KillLine
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardKillLine
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardKillWord

Set-PSReadLineKeyHandler -Chord Alt+b -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Alt+f -Function ForwardWord

# Tab 补全菜单
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete


# ==============================
# adb -s device completion
# ==============================

Register-ArgumentCompleter -Native -CommandName adb -ScriptBlock {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )

    $commandLineBeforeCursor = $commandAst.Extent.Text.Substring(
        0,
        [Math]::Min($cursorPosition, $commandAst.Extent.Text.Length)
    )

    # 只在 adb -s 后补全设备序列号
    if ($commandLineBeforeCursor -notmatch '(^|\s)-s\s+\S*$') {
        return
    }

    adb devices |
        Select-Object -Skip 1 |
        ForEach-Object {
            if ($_ -match '^(\S+)\s+device$') {
                $serial = $matches[1]

                if ($serial -like "$wordToComplete*") {
                    [System.Management.Automation.CompletionResult]::new(
                        "$serial ",
                        $serial,
                        'ParameterValue',
                        $serial
                    )
                }
            }
        }
}


# ==============================
# Notepad++ shortcut
# ==============================

function npp {
    & "D:\Software\npp.8.8.2.portable.x64\notepad++.exe" @args
}

# ==============================
# Prompt: Conda + Path + Git Branch
# Must be placed at the end to override Conda prompt
# ==============================

function global:prompt {

    $location = $ExecutionContext.SessionState.Path.CurrentLocation

    # 向 Windows Terminal 上报当前工作目录。
    # 用于恢复窗口时重新进入原目录，以及 Duplicate Tab 继承当前目录。
    if (
        $env:WT_SESSION -and
        $location.Provider.Name -eq 'FileSystem'
    ) {
        $providerPath = $location.ProviderPath
        $oscCwd = "$([char]27)]9;9;`"$providerPath`"$([char]27)\"

        Write-Host $oscCwd -NoNewline
    }

    $path = $location.Path

    Write-Host $path -ForegroundColor Cyan -NoNewline

    if (git rev-parse --is-inside-work-tree 2>$null) {

        $branch = git branch --show-current 2>$null
        if (-not $branch) {
            $branch = git rev-parse --short HEAD 2>$null
        }

        $status = git status --porcelain=v1 -b 2>$null

        $flags = ""

        if ($status | Select-String '^[ MARCUD]M|^M') {
            $flags += " *"
        }

        if ($status | Select-String '^\?\?') {
            $flags += " ?"
        }

        $ahead = 0
        $behind = 0

        $firstLine = $status[0]

        if ($firstLine -match 'ahead (\d+)') {
            $ahead = [int]$matches[1]
        }

        if ($firstLine -match 'behind (\d+)') {
            $behind = [int]$matches[1]
        }

        if ($ahead -gt 0) {
            $flags += " ↑"

            if ($ahead -gt 1) {
                $flags += $ahead
            }
        }

        if ($behind -gt 0) {
            $flags += " ↓"

            if ($behind -gt 1) {
                $flags += $behind
            }
        }

        $branchColor = "Green"

        if ($flags) {
            $branchColor = "Yellow"
        }

        Write-Host " [$branch$flags]" `
            -ForegroundColor $branchColor `
            -NoNewline
    }

    return "> "
}