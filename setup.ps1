if (-not [System.IO.File]::Exists(".\terraform.exe")) {
    Invoke-WebRequest -URI "https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_windows_amd64.zip" -OutFile "terraform.zip"
    Expand-Archive -Path .\terraform.zip -DestinationPath .\ -Force
}
.\terraform.exe -chdir="./infra" init 
.\terraform.exe -chdir="./infra" apply -auto-approve

$output = .\terraform.exe -chdir="./infra" output -json | ConvertFrom-Json
$key = $output.ec2_information.value.key_name + ".pem"
$server = "admin@" + $output.ec2_information.value.domain_name
$scp_directory = $server + ":~/server"

scp -o StrictHostKeyChecking=accept-new -r -i $key server $scp_directory
ssh -o StrictHostKeyChecking=accept-new -i $key $server "sudo sh server/startup.sh"