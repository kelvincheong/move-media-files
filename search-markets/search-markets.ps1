# Description: I want to search Facebook Marketplace, Gumtree and eBay for stuff. Using Firefox as it has FB Container.

Import-Module "C:\ps\selenium-powershell-master\Selenium.psd1"

function fnSearchEbay {
    #Enter-SeUrl https://www.ebay.com.au -Driver $Driver
    $Element = Find-SeElement -Driver $Driver -Id "gh-ac"
    Send-SeKeys -Element $Element -Keys "$mySearch"
    Send-SeKeys -Element $Element -Keys Keys.RETURN
}

# To start a Firefox Driver
#$Driver = Start-SeFirefox 
$mySearch = "27 monitor"
fnSearchEbay