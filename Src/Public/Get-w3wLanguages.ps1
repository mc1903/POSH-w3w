<#
	.Notes
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Function Name:		Get-w3wLanguages
	Module Name:		Posh-w3w
	Created by:			Martin Cooper (@mc1903)
	Date:				03/10/2021
	GitHub:				https://github.com/mc1903/Posh-w3w
	Version:			1.0.0
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	.Synopsis
	This function will retrieve a list all available 3 word address languages.

	.Description
	This function will retrieve a list all available 3 word address languages, 
    including the ISO 3166-1 alpha-2 2 letter code, english name and native name.

	.Parameter APIKey
	The w3w API key from your account - https://developer.what3words.com/public-api

	.Example
	# Get the latest list of available w3w address languages.
	Get-w3wLanguages -APIKey SP****TM
#>
Function Get-w3wLanguages {
    [CmdletBinding(
        SupportsShouldProcess=$False
    )]
    Param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String[]] $APIKey

    )

    #Force TLS 1.2 Connections
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    #Create Header Parameters
    $Header=@{}
    $Header.add("X-Api-Key","$APIKey")

    Try {
      Invoke-RestMethod -Method GET -Uri "https://api.what3words.com/v3/available-languages" -Headers $Header -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -OutVariable Output -ErrorVariable OutError | Out-Null
    } 
    Catch {
        $OutError = $_
    }
   
    If ($OutError) {
        Write-Error $OutError
    } Else {
        $Output
    }

}
