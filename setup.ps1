if (-not [System.IO.File]::Exists(".\terraform.exe")) {
    Invoke-WebRequest -URI "https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_windows_amd64.zip" -OutFile "terraform.zip"
    Expand-Archive -Path .\terraform.zip -DestinationPath .\ -Force
}
.\terraform.exe -chdir="./infra" init 
.\terraform.exe -chdir="./infra" apply -auto-approve