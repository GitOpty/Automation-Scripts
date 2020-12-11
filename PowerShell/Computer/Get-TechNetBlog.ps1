# Suported query parameters:
# tag

# Create an empty list to append results into
$ResultList = New-Object System.Collections.Generic.List[object]

# Set the URI, with or without a user-supplied tag
$BaseURI = 'https://blogs.technet.microsoft.com/heyscriptingguy'
if ($req_query_tag) {
    $BaseURI = "$BaseURI/tag/$req_query_tag"
}

try {
    # Get the latest 10 posts (RSS feed default is 10 per page)
    $iwr = Invoke-WebRequest -Uri "$BaseURI/feed" -UseBasicParsing
}
catch {
    # Invoke-WebRequest is weird. Just silently fail
}

if ($iwr) {
    # Cast the RSS feed as XML
    [xml]$xml = $iwr.Content

    foreach ($post in $xml.rss.channel.item) {
        # Assemble the most useful properties in an object
        $newObject = [PSCustomObject]@{
            Date        = $post.pubDate -as [DateTime]
            Title       = $post.Title
            Description = $post.Description.'#cdata-section'
            Link        = $post.Link
        }
        
        # Append the object into the collection
        [void]$ResultList.Add($newObject)
    }

    # Return the objects in JSON format. Azure Functions likes Out-String
    $return = $ResultList | ConvertTo-Json | Out-String

    # By default, Azure Functions want to output the contents of $res
    Out-File -Encoding Ascii -FilePath $res -InputObject $return
}
else {
    # Can't get Azure Functions to respect -Verbose, even trying this:
    #  https://justingrote.github.io/2017/12/25/Powershell-Azure-Functions-The-Missing-Manual.html#logs-panel-and-verbosedebug-output
    Write-Verbose "Invoke-WebRequest returned no results" 4>&1
}