# Accessing AWS Instance Metadata

#[System.Text.Encoding]::UTF8.GetString($byteArray)


Function Get-SIDInfo {
    $rtn=[PSCustomObject]@{status=0;cmdOut=$numm;errOut=$null}
    $admin = Get-LocalUser | Where-Object {$_.Sid.Value.EndsWith("500")}
    $rtn.cmdOut = [PSCustomObject]@{
        adminUser = $admin.Name;
        adminSid  = $admin.Sid.Value;
        computerName = [Environment]::MachineName;
        computerAccountSid = $admin.Sid.AccountDomainSid.value
    }
    $rtn | ConvertTo-Json
}


Function Get-GCPUserdataScript {

    $headers = @{"Metadata-Flavor"="Google"}
    $imds = "http://metadata.google.internal/computeMetadata/v1"
    $userdata =  Invoke-RestMethod -uri "$($imds)/instance/attributes/sysprep-specialize-script-ps1" -Headers $headers
    $userdata

}

Function Get-AWSUserdataScript {

    # IDMS v2 needs a token 
    $token = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token-ttl-seconds" = "21600"} -Method PUT -Uri http://169.254.169.254/latest/api/token
    $userdata = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token" = $token} -Method GET -Uri "http://169.254.169.254/latest/user-data"
    $userdata
}

Function Get-AWSMetadata {
    param (
        [String]$Endpoint="",
        [Switch]$AsJson
    )

    # IDMS v2 needs a token 
    $token = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token-ttl-seconds" = "21600"} -Method PUT -Uri http://169.254.169.254/latest/api/token
    $uri = "http://169.254.169.254/latest/meta-data"
    if ($Endpoint) {$uri = "{0}/{1}" -f $uri,$Endpoint}
    $metadata = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token" = $token} -Method GET -Uri $uri
    if ($AsJson) {
        return $metadata | Convertto-Json -Depth 10
    } else {
        return $metadata
    } 
}

Function Get-AzureCompute {
    param (
        [Switch]$AsJson
    )
    $uri = "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
    $data = Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri $uri
    if ($AsJson) {
        return $data | ConvertTo-Json -Depth 10
    } else {
        return $data
    }

}