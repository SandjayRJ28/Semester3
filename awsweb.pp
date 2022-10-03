#AWS Ubuntu image without appache2
ec2_instance { 'webserverlin':
 ensure => present,
 region => 'eu-central-1',
 availability_zone => 'eu-central-1a',
 image_id => 'ami-0add4790ba5940e85',
 instance_type => 't2.micro',
 monitoring => false,
 key_name => 'web-vpc',
 security_groups => ['secnat' , 'pinggroup' , 'secsg-ssh'],
 subnet => 'webvpc-pub-1a',
 associate_public_ip_address=> true,
 user_data => template ('/opt/puppetlabs/puppet/modules/aws-examples/web.sh'),
}

ec2_instance { 'webserverlin2':
 ensure => present,
 region => 'eu-central-1',
 availability_zone => 'eu-central-1a',
 image_id => 'ami-0add4790ba5940e85',
 instance_type => 't2.micro',
 monitoring => false,
 key_name => 'web-vpc',
 security_groups => ['secnat' , 'pinggroup' , 'secsg-ssh'],
 subnet => 'webvpc-pub-1a',
 associate_public_ip_address=> true,
 user_data => template ('/opt/puppetlabs/puppet/modules/aws-examples/web.sh'),
}

ec2_instance { 'webserverlin3':
 ensure => present,
 region => 'eu-central-1',
 availability_zone => 'eu-central-1a',
 image_id => 'ami-0add4790ba5940e85',
 instance_type => 't2.micro',
 monitoring => false,
 key_name => 'web-vpc',
 security_groups => ['secnat' , 'pinggroup' , 'secsg-ssh'],
 subnet => 'webvpc-pub-1a',
 associate_public_ip_address=> true,
 user_data => template ('/opt/puppetlabs/puppet/modules/aws-examples/web.sh'),
}
