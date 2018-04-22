$TopPSScriptRoot=$PsScriptRoot
$programfiles=${env:ProgramFiles}
$profpath=${env:profiles}
	if($profpath -eq $null) 
	{
		$profpath=sl -path "$PSScriptRoot\Profiles"
	}
$profiles =  dir $profpath

"-------------------------------------------------------------------------------"
"=== List of profiles "
"-------------------------------------------------------------------------------"
$profiles.Name
"-------------------------------------------------------------------------------"
if($profiles.Length -ge 1)
		{
			while($profilename -notlike "exit") {
			$profilename = Read-Host("Please enter profile name")
			$profiles | %	{
				if($_ -like $profilename) {
				$TopPSScriptRoot= sl -Path $PsscriptRoot\Profiles\$profilename
				break}
			}
				"Incorrect profile name, type 'exit' to return."
			
		}
	}
		else
		{
			$TopPSScriptRoot= sl -Path $PsscriptRoot\Profiles\$profilename
		}
$params =dir "$PSScriptRoot\Parameters"
$normalparams = $params.Name -Replace "[.].+$"
"-------------------------------------------------------------------------------"
"=== List of parameters "
"-------------------------------------------------------------------------------"
$params.Name
"-------------------------------------------------------------------------------"
while($paramname -notlike "exit") {
$paramname = Read-Host("Please enter parameter name")
	foreach ($par in $params.Name){
		if ($paramname -like $par){
			$neededparam=$paramname
			$m = 1
			break
		}
		}
	if ($m -eq 1){break}
	"Incorrect parameter name, type 'exit' to return."
	}

$files =  dir $TopPSScriptRoot
$string = dir $TopPSScriptRoot -recurse -Force | % {$_ | select-string -Pattern "__"}  
$stringCount = $string | Measure-Object| %{$_.Count}
$massive = $string | Out-String -Stream
$normalmassive = @()
$normalmassive = $massive -split "(__)"
$lengthmassive=$normalmassive.Length
$neededmassive = @{}
$t = 0;
for ($i=0; $i -le ($lengthmassive-1); $i++){
	if($normalmassive[$i] -like "__"){
	$i++	
	$neededmassive[$t]=$normalmassive[$i]
	$t=$t+1
	$i--
	}
}

$texts = @()
$texts = $neededmassive.Values -replace "'.*"
	$file = Get-Content "$PSScriptRoot\Parameters\$neededparam" | Out-String -Stream
	$nonvaluefile = $file -replace "__"
	$nonvaluefile = $nonvaluefile -replace "=(.+)"
	$valuefile = $file -replace "(.+)="
	$docker = dir "$PsScriptRoot\Profiles\$profilename\dockerfile.*" -recurse -Force |% {$_ | select-string -pattern " "} 
	$dockermassive = @()
	$dockermassive = $docker -replace "(.+)txt:\d+:"
	foreach($t in $file)
{
	if($t -match $null) {
		$result = $true
		break
	} 
	else {$result = $false 
	break}
}
	if($result -match $true)
{
	
	for ($i=0; $i -lt $texts.length ;$i++){
		$l=$l+1
	for($k=0; $k -lt $file.Length; $k++){if ($nonvaluefile[$k] -ilike $texts[$i] ){
	$truestr=$valuefile[$k] + " " + $truestr
		}
}
	
	}
	$truestr = $truestr -split (" ")
	[array]::Reverse($texts)
	for ($i=$texts.length; $i -ge 0 ;$i--){
	$dockermassive = $dockermassive -replace ($texts[$i],$truestr[$i])}	
	$dockermassive | out-file -FilePath $PsScriptRoot\Release\Product\dockerfile.* -Append  -Encoding utf8} 
	
	else{
	for($s=0; $s -lt $texts.Count; $s++) {
"-------------------------------------------------------------------------------"
"=== Name "
"-------------------------------------------------------------------------------"
$texts[$s]
"-------------------------------------------------------------------------------"
		$anothervalue = Read-Host("Please enter value for this name")
		$dockermassive = $dockermassive -replace ($texts[$s],$anothervalue)}	
		if($texts -and $anothervalue){
$dockermassive | out-file -FilePath $PsScriptRoot\Release\Product\dockerfile.* -Append  -Encoding utf8
			}
	}
pause