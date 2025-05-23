using namespace System.Net

Function Invoke-ExecGeoIPLookup {
    <#
    .FUNCTIONALITY
        Entrypoint,AnyTenant
    .ROLE
        CIPP.Core.Read
    #>
    [CmdletBinding()]
    param($Request, $TriggerMetadata)

    $APIName = $Request.Params.CIPPEndpoint
    $Headers = $Request.Headers
    Write-LogMessage -headers $Headers -API $APIName -message 'Accessed this API' -Sev 'Debug'

    $IP = $Request.Query.IP ?? $Request.Body.IP

    if (-not $IP) {
        $ErrorMessage = Get-NormalizedError -Message 'IP address is required'
        $LocationInfo = $ErrorMessage
    } else {
        $locationInfo = Get-CIPPGeoIPLocation -IP $IP
    }

    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::OK
            Body       = $LocationInfo
        })

}
