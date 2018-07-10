# Let's create the AD Groups - cluster scope
az ad group create --display-name ClusterViewAdmin --mail-nickname ClusterViewAdmin
az ad group create --display-name ClusterViewDev --mail-nickname ClusterViewDev
az ad group create --display-name ClusterViewOps --mail-nickname ClusterViewOps
az ad group create --display-name ClusterCreateAdmin --mail-nickname ClusterCreateAdmin
az ad group create --display-name ClusterCreateDev --mail-nickname ClusterCreateDev
az ad group create --display-name ClusterCreateOps --mail-nickname ClusterCreateOps
# Let's create the AD Groups - namespace NS1 scope
az ad group create --display-name NS1ViewAdmin --mail-nickname NS1ViewAdmin
az ad group create --display-name NS1ViewDev --mail-nickname NS1ViewDev
az ad group create --display-name NS1ViewOps --mail-nickname NS1ViewOps
az ad group create --display-name NS1CreateAdmin --mail-nickname NS1CreateAdmin
az ad group create --display-name NS1CreateDev --mail-nickname NS1CreateDev
az ad group create --display-name NS1CreateOps --mail-nickname NS1CreateOps
# Let's create the users - needs to be amended with your domain
az ad user create --display-name devopsbot --password OpsBotDev123! --user-principal-name devopsbot@[yourdomain].onmicrosoft.com --force-change-password-next-login true --immutable-id devopsbot
az ad user create --display-name devopsbot2 --password OpsBotDev123! --user-principal-name devopsbot2@[yourdomain].onmicrosoft.com --force-change-password-next-login true --immutable-id devopsbot2
