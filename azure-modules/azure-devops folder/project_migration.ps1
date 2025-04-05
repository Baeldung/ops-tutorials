param ( [string]$PAT ) # Set required variables 

$organizationName = "ourorg" # Source Azure DevOps Organization 
$projectNameFrom = "Project1" # Source Project 
$projectNameTo = "Project2" # Destination Project 
$scriptLocation = $PSScriptRoot # Location of the script

function Get-AuthHeader {
    param (
        [string]$token
    )
    return [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($token)"))
}

function Get-Repositories {
    param (
        [string]$organization,
        [string]$project,
        [string]$authHeader
    )
    $repoUrl = "https://dev.azure.com/$organization/$project/_apis/git/repositories/?api-version=7.1-preview.1"
    return Invoke-RestMethod -Uri $repoUrl -Method Get -Headers @{Authorization = "Basic $authHeader"}
}


function Enable-Repository {
    param (
        [string]$organization,
        [string]$project,
        [string]$repoId,
        [string]$authHeader
    )
    $updateRepoUrl = "https://dev.azure.com/$organization/$project/_apis/git/repositories/$repoId?api-version=7.1-preview.1"
    $updateRepoBody = @{ isDisabled = $false } | ConvertTo-Json

    try {
        Invoke-RestMethod -Uri $updateRepoUrl -Method Patch -Body $updateRepoBody -Headers @{Authorization = "Basic $authHeader"} -ContentType "application/json"
        Write-Host "Repository '$repoId' has been enabled."
    } catch {
        Write-Host "Failed to enable repository '$repoId': $_"
    }
}
function Test-RepositoryExists {
    param (
        [string]$organization,
        [string]$project,
        [string]$repoName,
        [string]$authHeader
    )
    $reposResponse = Get-Repositories -organization $organization -project $project -authHeader $authHeader
    $repositoriesList = $reposResponse.value
    return ($repositoriesList | Where-Object { $_.name -eq $repoName }).Count -ne 0
}

function Delete-Repository {
    param (
        [string]$organization,
        [string]$project,
        [string]$repoId,
        [string]$authHeader
    )
    $deleteRepoUrl = "https://dev.azure.com/$organization/$project/_apis/git/repositories/$repoId?api-version=7.1-preview.1"

    try {
        Invoke-RestMethod -Uri $deleteRepoUrl -Method Delete -Headers @{Authorization = "Basic $authHeader"}
        Write-Host "Repository '$repoId' has been deleted from '$project'."
    } catch {
        Write-Host "Failed to delete repository '$repoId': $_"
    }
}

function Move-DeprecatedRepository {
    param (
        [string]$organization,
        [string]$projectFrom,
        [string]$projectTo,
        [string]$repoId,
        [string]$repoName,
        [string]$repoSshUrl,
        [string]$authHeader
    )
    
    try {
        $repoToUrl = "https://dev.azure.com/$organization/$projectTo/_apis/git/repositories?api-version=7.1-preview.1"
        $repoToBody = @{ name = $repoName } | ConvertTo-Json

        $repoToResponse = Invoke-RestMethod -Uri $repoToUrl -Method Post -Body $repoToBody -Headers @{Authorization = "Basic $authHeader"} -ContentType "application/json"
        $newRepoUrl = $repoToResponse.sshUrl
        Write-Host "Repository creation successful for '$repoName'."

        # Clone, Add Remote, and Push
        $localClonePath = "$scriptLocation\$repoName"
        git clone --mirror $repoSshUrl $localClonePath
        Set-Location -Path $localClonePath
        git remote add new-origin $newRepoUrl
        git push new-origin --all
        git push new-origin --tags

        # Clean up
        Set-Location -Path ..
        Remove-Item -Recurse -Force $localClonePath
        Write-Host "Repository '$repoName' moved successfully."

        # Delete original repository
        Delete-Repository -organization $organization -project $projectFrom -repoId $repoId -authHeader $authHeader
        return $true
    } catch {
        Write-Host "Error moving repository '$repoName': $_"
        return $false
    }
}

try {
    $authHeader = Get-AuthHeader -token $personalAccessToken
    $FromRepoResponse = Get-Repositories -organization $organizationName -project $projectNameFrom -authHeader $authHeader
    $repositoriesList = $FromRepoResponse.value

    # Enable disabled repositories
    foreach ($repo in $repositoriesList | Where-Object { $_.IsDisabled -eq $true }) {
        Enable-Repository -organization $organizationName -project $projectNameFrom -repoId $repo.id -authHeader $authHeader
    }

    # Move deprecated repositories
    $failedRepositories = @()
    foreach ($repo in $repositoriesList | Where-Object { $_.name -like "*Deprecated*" }) {  
        if (-not (Move-DeprecatedRepository -organization $organizationName -projectFrom $projectNameFrom -projectTo $projectNameTo -repoId $repo.id -repoName $repo.name -repoSshUrl $repo.sshUrl -authHeader $authHeader)) {
            $failedRepositories += $repo.name
        }
    }

    # Display failures
    if ($failedRepositories.Count -gt 0) {
        Write-Host "`nRepositories that failed to move:" $failedRepositories
    }
} catch {
    Write-Host "An error occurred: $_"
}


