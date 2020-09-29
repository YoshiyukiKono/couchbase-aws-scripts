https://docs.couchbase.com/server/current/rest-api/rest-node-provisioning.html

```
// Initialize Node
curl -u Administrator:password -v -X POST http://[localhost]:8091/nodes/self/controller/settings
  -d path=[location]
  -d index_path=[location]
  -d cbas_path=[location]
  -d eventing_path=[location]

// Rename Node
curl -u Administrator:password -v -X POST http://[localhost]:8091/node/controller/rename
  -d hostname=[localhost]

// Setup Services
curl -u Administrator:password -v -X POST http://[localhost]:8091/node/controller/setupServices
  -d services=[kv | index | n1ql | fts | cbas | eventing]

// Set Memory Quotas
curl -u Administrator:password -v -X POST http://[localhost]:8091/pools/default
  -d memoryQuota=[value]
  -d indexMemoryQuota=[value]
  -d ftsMemoryQuota=[value]
  -d cbasMemoryQuota=[value]
  -d eventingMemoryQuota=[value]

// Setup Administrator username and password
curl -u Administrator:password -v -X POST http://[localhost]:8091/settings/web
  -d password=[password]
  -d username=[admin-name]
  -d port=8091

// Setup Bucket
curl -u Administrator:password -v -X POST http://[localhost]:8091/pools/default/buckets
  -d flushEnabled=[1 | 0]
  -d replicaNumber=[0 - n]
  -d evictionPolicy=[valueOnly | full]
  -d ramQuotaMB=[value]
  -d bucketType=[membase | couchbase]
  -d name=[bucket-name]
```

https://docs.couchbase.com/server/current/analytics/rest-links.html

```

# Initialize the cluster
$cmd = "curl.exe -X POST http://" + $ec2PublicIpAddress + ":8091/node/controller/setupServices -d 'services=kv%2Cn1ql%2Cindex%2Cfts%2Ceventing'"
Invoke-Expression $cmd
$cmd = "curl.exe -X POST http://" + $ec2PublicIpAddress + ":8091/pools/default -d memoryQuota=8096 -d indexMemoryQuota=2048 -d ftsMemoryQuota=2048 -d eventingMemoryQuota=512"
Invoke-Expression $cmd
$cmd = "curl.exe -u Administrator:password -X POST http://" + $ec2PublicIpAddress + ":8091/settings/web -d password=password -d username=Administrator -d port=8091"
Invoke-Expression $cmd
Start-Sleep -Seconds 10

# Create bucket
$cmd = "curl.exe -u Administrator:password -X POST http://" + $ec2PublicIpAddress + ":8091/pools/default/buckets -d replicaNumber=0 -d ramQuotaMB=600 -d bucketType=couchbase -d name=cars"
Invoke-Expression $cmd
Start-Sleep -Seconds 10

# Load dataset
$cmd = "scp.exe -o ""StrictHostKeyChecking=no"" -i " + $keyPairFile + " " + $dataset + " ec2-user@" + $ec2PublicIpAddress + ":\tmp\sampleData.json"
Invoke-Expression $cmd
ssh.exe -o "StrictHostKeyChecking=no" -i $keyPairFile ec2-user@$ec2PublicIpAddress "/opt/couchbase/bin/cbimport json -c couchbase://127.0.0.1 -u Administrator -p password -b cars -d file:///tmp/sampleData.json -f lines -g %VIN%::#UUID#"

#########################
# Configure XDCR
#########################
Write-Output "Configuring XDCR..."
$remoteIpAddress = "3.1.126.230"

# Create bucket on remote cluster
$cmd = "curl.exe -u Administrator:password -X POST http://" + $remoteIpAddress + ":8091/pools/default/buckets -d replicaNumber=0 -d ramQuotaMB=600 -d bucketType=couchbase -d name=cars"
Invoke-Expression $cmd
Start-Sleep -Seconds 10

#Create remote cluster connection on local cluster
$cmd = "curl.exe -X POST -u Administrator:password http://" + $ec2PublicIpAddress + ":8091/pools/default/remoteClusters -d username=Administrator -d password=password -d hostname=" + $remoteIpAddress + " -d name=remoteCluster -d demandEncryption=0" 
Invoke-Expression $cmd
#Create remote cluster connection on remote cluster
$cmd = "curl.exe -X POST -u Administrator:password http://" + $remoteIpAddress + ":8091/pools/default/remoteClusters -d username=Administrator -d password=password -d hostname=" + $ec2PublicIpAddress + " -d name=remoteCluster -d demandEncryption=0" 
Invoke-Expression $cmd
Start-Sleep -Seconds 5
#Create XDCR replication on local cluster
$cmd = "curl.exe -X POST -u Administrator:password http://" + $ec2PublicIpAddress + ":8091/controller/createReplication -d fromBucket=cars -d toCluster=remoteCluster -d toBucket=cars -d replicationType=continuous -d enableCompression=1" 
Invoke-Expression $cmd
#Create XDCR replication on remote cluster
$cmd = "curl.exe -X POST -u Administrator:password http://" + $remoteIpAddress + ":8091/controller/createReplication -d fromBucket=cars -d toCluster=remoteCluster -d toBucket=cars -d replicationType=continuous -d enableCompression=1" 
Invoke-Expression $cmd

#########################
# Create remote link
#########################
Write-Output "Configuring Remote Link..."
#Create user on local cluster for remote link
$cmd = "curl.exe -X PUT -u Administrator:password http://" + $ec2PublicIpAddress + ":8091/settings/rbac/users/local/remote.demo01 -d password=password -d roles=data_dcp_reader[*]" 
Invoke-Expression $cmd
#Create remote link on remote cluster which points to local cluster
Start-Sleep -Seconds 5 #Wait for user being created on cluster. Otherwise createing remote link will fail sometime.
$cmd = "curl.exe -X POST -u Administrator:password http://" + $remoteIpAddress + ":8095/analytics/link -d dataverse=Default -d name=remoteLinkDemo01 -d type=Couchbase -d hostname=" + $ec2PublicIpAddress + " -d username=remote.demo01 -d password=password -d encryption=none" 
Invoke-Expression $cmd
#Create dataset on remote cluster
$cmd = "curl.exe -u Administrator:password --data-urlencode ""statement=create dataset cars ON cars AT remoteLinkDemo01;"" http://" + $remoteIpAddress + ":8095/analytics/service" 
Invoke-Expression $cmd
Start-Sleep -Seconds 5 #Wait for dataset being created
#Connect remote link on remote cluster
$cmd = "curl.exe -u Administrator:password --data-urlencode ""statement=connect link remoteLinkDemo01;"" http://" + $remoteIpAddress + ":8095/analytics/service" 
Invoke-Expression $cmd

```
