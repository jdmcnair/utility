REM installing various tools
REM To download jq utility into git bash:
REM curl -L -o /usr/bin/jq.exe https://github.com/jqlang/jq/releases/latest/download/jq-win64.exe

REM Development
choco install -y 7zip
choco install -y nvm
choco install -y git
choco install -y kubernetes-helm
choco install -y kubectl
choco install -y azure-kubelogin
choco install -y azure-cli
choco install -y vscode
choco install -y notepadplusplus
choco install -y terraform
REM choco install -y gitkraken
REM choco install -y virtualbox
REM choco install -y docker-toolbox
REM choco install -y vagrant
choco install -y anaconda3 --params '"/AddToPath"'
choco install -y mongodb
choco install -y studio3t
choco install -y make
choco install -y postman
choco install -y openlens --version=6.2.3
choco install -y winscp.install
choco install -y openvpn
REM choco install -y tortoisesvn
REM below has an issue with login
REM choco install -y oracle-sql-developer --params="'/Username:jmcnair@surgeforward.com /Password:xxxx'"
choco install -y sql-server-management-studio

REM choco install docker-desktop

REM Utilities
REM choco install -y conemu
REM choco install -y slack
REM choco install -y sourcetree
choco install -y gimp
choco install -y greenshot
choco install -y mremoteng
choco install -y microsoftazurestorageexplorer

REM Media
choco install -y vlc

REM AHQ allocations requirements
REM choco install -y jdk8
REM choco install -y python2 -- instead install python2 through anaconda
REM choco install -y pip
REM choco install -y oracle-sql-developer

REM not useful for AHQ requirements
REM choco install -y vcredist2013
REM choco install -y microsoft-build-tools
