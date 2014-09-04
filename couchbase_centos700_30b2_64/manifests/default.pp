# ===
# Install and Run Couchbase Server
# ===

$version = "3.0.0-beta2"
$filename = "couchbase-server_3.0.0-beta2_x86_64_centos6.rpm"

# ===
# Speed up Name Server Resolution
# ===
exec { "echo %Qnameserver 8.8.4.4%Q >> /etc/resolv.conf":
        path => "/usr/bin"
}
exec { "echo %Qnameserver 8.8.8.8%Q >> /etc/resolv.conf":
        path => "/usr/bin"
}
exec { "echo %Qnameserver 127.0.0.1%Q >> /etc/resolv.conf":
        path => "/usr/bin"
}

# Download the Sources
exec { "couchbase-server-source":
    command => "/usr/bin/wget http://packages.couchbase.com/releases/$version/$filename",
    cwd => "/home/vagrant/",
    creates => "/home/vagrant/$filename",
    before => Package['couchbase-server']
}

# ===
# Update the System  -- Uncomment to have system automatically update at install
# ===
#  exec { "yum -y update":
# 	path => "/usr/bin"
# }

# Remove Firewalld
exec { "yum -y remove firewalld":
        path => "/usr/bin"
}
# Install Couchbase Server
package { "couchbase-server":
    provider => rpm,
    ensure => installed,
    source => "/home/vagrant/$filename"
}

# Ensure the service is running
service { "couchbase-server":
	ensure => "running",
	require => Package["couchbase-server"]
}
