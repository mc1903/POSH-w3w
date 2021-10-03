<#
	.Notes
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Function Name:		Convert-CoordinatesTo3wa
	Module Name:		Posh-w3w
	Created by:			Martin Cooper (@mc1903)
	Date:				03/10/2021
	GitHub:				https://github.com/mc1903/Posh-w3w
	Version:			1.0.1
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	.Synopsis
	This function will convert a latitude and longitude to a w3w address.

	.Description
	This function will convert a latitude and longitude to a w3w address 
	in the language of your choice.

	.Parameter APIKey
	The w3w API key from your account - https://developer.what3words.com/public-api

	.Parameter Latitude
	The location's latitude using decimal degrees (DD) notation.

	.Parameter Longitude
	The location's longitude using decimal degrees (DD) notation.

	.Parameter Language
	The preferred language as an ISO 639-1 2 letter code.

	.Parameter Format
	The preferred output format (json or geojson).

	.Example
	# Get the w3w address for Gandalf Corner, London
	Convert-CoordinatesTo3wa -APIKey SP****TM -Latitude 51.525294 -Longitude -0.145747
#>
Function Convert-CoordinatesTo3wa {
    [CmdletBinding(
        SupportsShouldProcess=$False
    )]
    Param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String[]] $APIKey,

        [Parameter(Mandatory=$True)]
        [ValidatePattern("^(-?[1-8]?\d(?:\.\d{1,8})?|90(?:\.0{1,8})?)$")]
        [Alias("Lat")]
        [String[]] $Latitude,

        [Parameter(Mandatory=$True)]
        [ValidatePattern("^(-?(?:1[0-7]|[1-9])?\d(?:\.\d{1,8})?|180(?:\.0{1,8})?)$")]
        [Alias("Lng")]
        [String[]] $Longitude,

        [Parameter(Mandatory=$False)]
        [ValidatePattern("^(af|am|ar|bg|bn|cs|cy|da|de|el|en|es|fa|fi|fr|gu|he|hi|hu|id|it|ja|kn|ko|ml|mn|mr|ms|ne|nl|no|or|pa|pl|pt|ro|ru|sk|sv|sw|ta|te|th|tr|uk|ur|vi|xh|zh|zu)$")]
        [Alias("Lang")]
        [String[]] $Language,

        [Parameter(Mandatory=$False)]
        [ValidateSet("json","geojson")]
        [String[]] $Format
    )

    If(!$Language){
        $Language="en"
    }

    If(!$Format){
        $Format="json"
    }

    #Force TLS 1.2 Connections
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    #Create Header Parameters
    $Header=@{}
    $Header.add("X-Api-Key","$APIKey")

    Try {
      Invoke-RestMethod -Method GET -Uri "https://api.what3words.com/v3/convert-to-3wa?coordinates=$($Latitude),$($Longitude)&language=$($Language)&format=$($Format)" -Headers $Header -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -OutVariable Output -ErrorVariable OutError | Out-Null
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
