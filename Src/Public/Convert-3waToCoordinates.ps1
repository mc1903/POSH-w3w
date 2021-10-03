<#
	.Notes
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Function Name:		Convert-3waToCoordinates
	Module Name:		Posh-w3w
	Created by:			Martin Cooper (@mc1903)
	Date:				03/10/2021
	GitHub:				https://github.com/mc1903/Posh-w3w
	Version:			1.0.1
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	.Synopsis
	This function converts a w3w address to a latitude and longitude.

	.Description
	This function converts a w3w address to a latitude and longitude 

	.Parameter APIKey
	The w3w API key from your account - https://developer.what3words.com/public-api

	.Parameter Words
	The w3w address. It must be three words separated with dots.

	.Parameter Format
	The preferred output format (json or geojson).

	.Example
	# Get the latitude and longitude for Gandalf Corner, London from its w3w address.
	Convert-3waToCoordinates -APIKey SP****TM -Words forget.glory.mount
#>
Function Convert-3waToCoordinates {
    [CmdletBinding(
        SupportsShouldProcess=$False
    )]
    Param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String[]] $APIKey,

        [Parameter(Mandatory=$True)]
        [ValidatePattern("^\p{L}+\.\p{L}+\.\p{L}+$")]
        [Alias("3wa")]
        [String[]] $Words,

        [Parameter(Mandatory=$False)]
        [ValidateSet("json","geojson")]
        [String[]] $Format
    )

    If(!$Format){
        $Format="json"
    }

    #Force TLS 1.2 Connections
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    #Create Header Parameters
    $Header=@{}
    $Header.add("X-Api-Key","$APIKey")

    Try {
      Invoke-RestMethod -Method GET -Uri "https://api.what3words.com/v3/convert-to-coordinates?words=$($Words)&format=$($Format)" -Headers $Header -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -OutVariable Output -ErrorVariable OutError | Out-Null
    } 
    Catch {
        $OutError = $_
    }
   
    If ($OutError) {
        Write-Error $OutError
    } Else {
        $Output | Format-List
    }

}
