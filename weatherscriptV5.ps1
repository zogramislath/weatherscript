<#
How the script should work:
1. The script asks the user to either write "GBG" (for Gothenburg) or "STO" (for Stockholm)
2. Whether the user types "GBG" or "STO" the $location variable will be set to 'GBG' or 'STO'. The question will loop if they type anything else
3. If $location equals 'GBG' or 'STO' the function "Get-Weather" should run
4. Depending on $location the script sets the path to the XML file with $XMLPath
5. The script should then check if the XML file exists or if it doesn't, and sets either $XMLExists to True or False
6. Now it should start executing the functions. If the XML already exists it should check if it is more than 15 minutes old, and if so update it.
   If the XML doesn't exist it should download the XML from the API.
7. Now it should read the XML file with the function "ReadXML" and then write the actual weather to the user with function "WriteResultsToConsole"
#>


clear-host

#Set-ExecutionPolicy unrestricted


function Get-Weather {

    #checks what location the user specified and sets the path to the XML file
    #if ($location -eq 'GBG') {GBGDownloadXML}
    #if ($location -eq 'STO') {STODownloadXML}


    #Downloads XML for Gothenburg if the script runs for the first time
    function GBGDownloadXML {
    $GLOBAL:xml = Invoke-RestMethod -uri https://www.yr.no/sted/Sverige/V%C3%A4stra_G%C3%B6taland/G%C3%B6teborg/varsel.xml
    }
    
    #Downloads XML for Stockholm if the script runs for the first time
    function STODownloadXML {
    $GLOBAL:xml = Invoke-RestMethod -uri https://www.yr.no/sted/Sverige/Stockholm/Stockholm/varsel.xml
    }   

    #Sleep before reading XML 
    Start-Sleep -s 1

    #Reads XML file and sets variables
    function ReadXML {
        #write-host "Reading XML..."
        #[xml]$xml = Get-Content -path $XMLPath
        #write-host "XML location is" $XMLPath

        $GLOBAL:temperature = $xml.weatherdata.forecast.tabular.time[0].temperature.value
        $GLOBAL:weather = $xml.weatherdata.forecast.tabular.time[0].symbol.name
        $GLOBAL:weathertomorrow = $xml.weatherdata.forecast.tabular.time[4].symbol.name
        $GLOBAL:sunrise = $xml.weatherdata.sun.rise
        $GLOBAL:sunset = $xml.weatherdata.sun.set
        
    }

    #Writes information to the console
    function WriteResultsToConsole {
        $clock = (get-date -Format g)
        write-host "`nThe date is" $clock "and the weather is" $weather "and the temperature is" $temperature "°C" 
        write-host "The sunrise is at" $sunrise "and the sunset is at" $sunset

        write-host "Tomorrow the weather will be" $weathertomorrow
        }





#Executes the functions
if ($location -eq 'GBG') {GBGDownloadXML}
if ($location -eq 'STO') {STODownloadXML}
ReadXML
WriteResultsToConsole

}


do {
#Clear-Variable -name location
#write-host $location
$location = Read-host -prompt "Choose your location, write either GBG or STO"
#write-host $location
if ($location -eq 'GBG' -or $location -eq 'STO') {Get-Weather}
else {write-host "Please choose GBG or STO"}
#write-host $location

}
until (($location -eq "GBG") -or ($location -eq "STO"))






