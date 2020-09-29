In short, the steps are:
- couchbase-cli node-init
- couchbase-cli cluster-init
 
This is an example which I executed.
```
$ couchbase-cli node-init -c localhost -u placeholdername -p placeholderpwd --node-init-hostname ec2-18-217-78-159.us-east-2.compute.amazonaws.com

SUCCESS: Node initialized

$ couchbase-cli cluster-init --cluster localhost --cluster-username Administrator --cluster-password couchbase --services data --cluster-name Cluster4

SUCCESS: Cluster initialized
```
 
*Please note that the parameter of the option -c/--cluster is corresponding to the host that you send your request via the command.

Please refer to our documentation for details (I cited some sentences).

https://docs.couchbase.com/server/6.6/manage/manage-nodes/initialize-node.html

> Note that the command requires that a username and password be specified, although the node has not yet been provisioned with credentials. Placeholders are therefore provided: these can be overwritten during subsequent provisioning.
 
https://docs.couchbase.com/server/current/cli/cbcli/couchbase-cli-node-init.html

> In particular this command allows the user to set the data path, index path, analytics path, java home and hostname. These settings must be set prior to initializing the cluster or adding the node to an existing cluster as they cannot be changed later. 
