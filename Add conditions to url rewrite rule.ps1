####### Define the following parameters 
$blockedURIs = '*/test1/*','*/test2/*'
$Websitename = 'Default Web Site'
$RuleName = 'RequestBlockingRule1 with spaces'

####### Get a list of all conditions currently defined in the above rule
$listofcollections = Get-WebConfigurationProperty -PSPath "MACHINE/WEBROOT/APPHOST/$Websitename" -Filter "/system.webServer/rewrite/rules/rule[@name='$RuleName']/conditions" -Name collection | select -ExpandProperty pattern

ForEach($URI in $blockedURIs){
$list = @{
 pspath = "MACHINE/WEBROOT/APPHOST/$Websitename"
 filter = "/system.webServer/rewrite/rules/rule[@name='$RuleName']/conditions"
 Value = @{
    input = '{REQUEST_URI}'
    matchType ='Pattern'
    pattern =$URI
    ignoreCase ='True'
    negate ='False'
}
}

if ($URI -notin $listofcollections) {
    Add-WebConfiguration @list
    }
else {
    Write-Output "$URI is already added as a condition."
    }
}
