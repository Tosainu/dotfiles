# Put this file in ~/Documents/WindowsPowerShell/ and
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# https://docs.microsoft.com/en-us/powershell/module/psreadline/set-psreadlineoption
Set-PSReadLineOption `
    -BellStyle None `
    -EditMode Emacs `
    -HistoryNoDuplicates:$true `
    -HistorySearchCursorMovesToEnd:$true `
    -Colors @{
        'Command' = [ConsoleColor]::Green
        'Comment' = [ConsoleColor]::Gray
        'ContinuationPrompt' = [ConsoleColor]::White
        'Default' = [ConsoleColor]::White
        'Emphasis' = [ConsoleColor]::White
        'Error' = [ConsoleColor]::Red
        'InlinePrediction' = [ConsoleColor]::White
        'Keyword' = [ConsoleColor]::White
        'Member' = [ConsoleColor]::White
        'Number' = [ConsoleColor]::White
        'Operator' = [ConsoleColor]::White
        'Parameter' = [ConsoleColor]::White
        'String' = [ConsoleColor]::Yellow
        'Type' = [ConsoleColor]::White
        'Variable' = [ConsoleColor]::Green
    }

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_prompts
function prompt {
    Write-Host ""
    Write-Host "$env:UserName@$env:Computername " -ForegroundColor Yellow -NoNewLine
    Write-Host "$(Get-Location)" -ForegroundColor Green
    return "> "
}
