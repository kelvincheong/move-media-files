# Description: I want to search Facebook Marketplace, Gumtree and eBay for stuff. Using Firefox as it has FB Container.

Import-Module "C:\ps\selenium-powershell-master\Selenium.psd1"

function fnSearchEbay {
    Enter-SeUrl https://www.ebay.com.au -Driver $Driver
    $Element = Find-SeElement -Driver $Driver -Id "gh-ac"
    Send-SeKeys -Element $Element -Keys "$mySearch"
    Send-SeKeys -Element $Element -Keys ([OpenQA.Selenium.Keys]::Enter)
}

function fnSearchGumtree {
    Enter-SeUrl https://www.gumtree.com.au -Driver $Driver
    $Element = Find-SeElement -Driver $Driver -Id "search-query"
    Send-SeKeys -Element $Element -Keys "$mySearch"

    $Element2 = Find-SeElement -Driver $Driver -Id "search-area"
    Send-SeKeys -Element $Element2 -Keys "Balwyn North"

    Send-SeKeys -Element $Element -Keys ([OpenQA.Selenium.Keys]::Enter)
}

function fnSearchFB {
    #Enter-SeUrl https://www.facebook.com/marketplace/ -Driver $Driver
    #$Element = Find-SeElement -Driver $Driver -Id "gh-ac"
    
    
    #Send-SeKeys -Element $Element -Keys "$mySearch"
    #Send-SeKeys -Element $Element -Keys ([OpenQA.Selenium.Keys]::Enter)
}

$Driver = Start-SeChrome
$mySearch = "27 monitor"
#fnSearchEbay
#fnSearchGumtree
fnSearchFB
