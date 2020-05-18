# Description: I want to search Facebook Marketplace, Gumtree and eBay for stuff. Using Firefox as it has FB Container.

Import-Module "C:\ps\selenium-powershell-master\Selenium.psd1"

function fnSearchEbay {
    Enter-SeUrl https://www.poshud.com -Driver $Driver
}

# To start a Firefox Driver
$Driver = Start-SeFirefox 

