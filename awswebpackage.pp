ec2_instance { 'webpack1':
 ensure => present,
 region => 'eu-central-1',
 availability_zone => 'eu-central-1a',
 image_id => 'ami-065deacbcaac64cf2',
 instance_type => 't2.micro',
 monitoring => false,
 key_name => 'web-vpc',
 security_groups => ['secnat' , 'pinggroup' , 'secsg-ssh'],
 subnet => 'webvpc-pub-1a',
 associate_public_ip_address=> true,
 user_data => template ('/opt/puppetlabs/puppet/modules/aws-examples/web.sh'),
}

ec2_instance { 'webpack2':
 ensure => present,
 region => 'eu-central-1',
 availability_zone => 'eu-central-1a',
 image_id => 'ami-065deacbcaac64cf2',
 instance_type => 't2.micro',
 monitoring => false,
 key_name => 'web-vpc',
 security_groups => ['secnat' , 'pinggroup' , 'secsg-ssh'],
 subnet => 'webvpc-pub-1a',
 associate_public_ip_address=> true,
 user_data => template ('/opt/puppetlabs/puppet/modules/aws-examples/web.sh'),
}

ec2_instance { 'webpack3':
 ensure => present,
 region => 'eu-central-1',
 availability_zone => 'eu-central-1a',
 image_id => 'ami-065deacbcaac64cf2',
 instance_type => 't2.micro',
 monitoring => false,
 key_name => 'web-vpc',
 security_groups => ['secnat' , 'pinggroup' , 'secsg-ssh'],
 subnet => 'webvpc-pub-1a',
 associate_public_ip_address=> true,
 user_data => template ('/opt/puppetlabs/puppet/modules/aws-examples/web.sh'),
}



