#creeren van VPC
ec2_vpc { 'webvpc':                                             #Naam van VPC
 ensure => present,                                             #Defineer met present voor creeren of absent voor verwijderen
 region => 'eu-central-1',                                      #Defineer Region
 cidr_block => '10.0.0.0/16',                                   #Defineer NetworkID/Subnet
 }

#Het aanmaken van de Internet Gateway
ec2_vpc_internet_gateway { 'webvpc-igw':                        #Naam van de Gateway
 ensure => present,                                             #Defineer met present voor creeren of absent voor verwijderen
 region => 'eu-central-1',                                      #Defineer Region
 vpc => 'webvpc',                                               #Koppelen aan je VPC
 }

#Security group voor SSH
ec2_securitygroup { 'secsg-ssh':                                #Naam van Security Group
 ensure => present,                                             #Defineer met present voor creeren of absent voor verwijderen
 region => 'eu-central-1',                                      #Defineer Region
 vpc => 'webvpc',                                               #Koppelen aan je VPC
 description => 'Security group for SSH',                       #Descriptie voor je Security Group
 ingress => [ {                                                 #Defineer je inbound rule
   protocol => 'tcp',                                           #Geef aan welke Protocol
   port => 22,                                                  #Welke poort open moet gaan
   cidr => '0.0.0.0/0'                                          #Destination voor je IP
   }]
 }

#Security group voor NAT
ec2_securitygroup { 'secnat':                                   #Naam van Security Group
 ensure => present,                                             #Defineer met present voor creeren of absent voor verwijderen
 region => 'eu-central-1',                                      #Defineer Region
 vpc => 'webvpc',                                               #Koppelen aan je VPC
 description => 'Security group for nat server',                #Descriptie voor je Security Group
 ingress => [ {                                                 #Defineer je inbound rule
   protocol => 'tcp',                                           #Geef aan welke Protocol
   port => 22,                                                  #Welke poort open moet gaan
   security_group => 'secsg-ssh',                               #Destination voor je IP
   },{                                                          #Herhaal deze code om meer inbount rules toe te voegen
   protocol => 'tcp',
   port => 80,
   cidr => '0.0.0.0/0'
   },{
   protocol => 'tcp',
   port => 443,
   cidr_block => '0.0.0.0/0'
   },{
   protocol => 'tcp',
   port => 8000,
   cidr_block => '0.0.0.0/0'
   }
   ]
}

#Security group voor het pingen van de machines
ec2_securitygroup { 'pinggroup':
 ensure => present,
 region => 'eu-central-1',
 vpc => 'webvpc',
 description => 'Security group for ICMP',
 ingress => [{
   type => 'All ICMP - IPv4',
   port => 'All',
   cidr => '0.0.0.0/0',
  }]

 }

#Aanmaken route table voor de public subnet
ec2_vpc_routetable { 'webvpc-rt-pub-1a':                        #Naam voor je public route table
 ensure => present,                                             #Defineer met present voor creeren of absent voor verwijderen
 region => 'eu-central-1',                                      #Defineer Region
 vpc => 'webvpc',                                               #Koppelen aan je VPC
 routes => [                                                    #Routes defineren
   {
     destination_cidr_block => '10.0.0.0/16',                   #Route naar je lokale subnet van je VPC
     gateway => 'local'                                         #Type route local
   },{
     destination_cidr_block => '0.0.0.0/0',                     #Route naar buiten toe
     gateway => 'webvpc-igw'                                    #Naar de gateway
   },
  ],
 }

#Aanmaken van de public subnet
ec2_vpc_subnet { 'webvpc-pub-1a':                               #Naam voor public subnet
 ensure => present,                                             #Defineer met present voor creeren of absent voor verwijderen
 region => 'eu-central-1',                                      #Defineer Region
 vpc => 'webvpc',                                               #Koppelen aan je VPC
 cidr_block => '10.0.0.0/20',                                   #Kies een IP die in de local range zit van je VPC
 availability_zone => 'eu-central-1a',                          #Kies een Availability zone. Dit kan je vinden op AWS
 route_table => 'webvpc-rt-pub-1a',                             #Welke route table wordt gekoppeld
 }

#NAT instance aanmaken
ec2_instance { 'webvpc-nat-1a':                                 #Naam van de Instance
 ensure => present,                                             #Defineer met present voor creeren of absent voor verwijderen
 region => 'eu-central-1',                                      #Defineer Region
 availability_zone => 'eu-central-1a',                          #Kies een Availability zone. Dit kan je vinden op AWS
 image_id => 'ami-027ec8cf931500e04',                           #AMI ID invoeren
 instance_type => 't2.micro',                                   #Instance type
 monitoring => false,                                           #Monitoring optie
 key_name => 'web-vpc',                                         #Aangemaakte keypair invoeren
 security_groups =>                                             #Welke security group toegevoegd wordt
 ['secnat'],
 subnet => 'webvpc-pub-1a',                                     #Welke subnet
 associate_public_ip_address=> true,                            #Optie voor Public IP
 }

#Route table aanmaken voor private subnet
ec2_vpc_routetable { 'webvpc-rt-priv-1a':                       #Naam route table
 ensure => present,                                             #Defineer met present voor creeren of absent voor verwijderen
 region => 'eu-central-1',                                      #Defineer Region
 vpc => 'webvpc',                                               #Koppeling aan gewenste VPC
 routes => [{                                                   #Defineer de routes
   destination_cidr_block => '10.0.0.0/16',                     #Local Subnet van je VPC
   gateway => 'local'                                           #Type van je route local
  },{
   destination_cidr_block => '0.0.0.0/0',                       #Defineer uitgaande route
   gateway => 'webvpc-nat-1a'                                   #Gateway
  },
  ]
 }

#Private subnet aanmaken voor de machines
ec2_vpc_subnet { 'webvpc-priv-1a':                              #Naam subnet
 ensure => present,                                             #Defineer met present voor creeren of absent voor verwijderen
 region => 'eu-central-1',                                      #Defineer Region
 vpc => 'webvpc',                                               #Koppelen aan VPC
 cidr_block => '10.0.128.0/20',                                 #Subnet ID
 availability_zone => 'eu-central-1a',                          #Availibility zone invoeren. Dit kan je vinden op AWS
 route_table => 'webvpc-rt-priv-1a',                            #Koppelen aan de route table
 }
