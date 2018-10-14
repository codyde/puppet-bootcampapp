plan profiles::bootcampapp (
	TargetSpec $nodes
) {

   $nodes.apply_prep

   apply($nodes) {
       $html_dir = '/var/www/html'

       Package {'nginx':
         ensure => present,
       }

   exec { 'git clone':
     command => '/usr/bin/git clone -b standalone-p https://github.com/codyde/cmbu-bootcamp-app /tmp/cmbu-bootcamp-app'
   }


   file { "/tmp/cmbu-bootcamp-app/frontend-tier/src/app/app.component.html":
    ensure  => file,
    force   => true,
    content => epp('/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.0.0/modules/profiles/templates/app.component.html.epp'),
    require => Exec['git clone']
    }

   file { "/etc/nginx/conf.d/default.conf":
     ensure => file,
     force  => true, 
     source => '/tmp/cmbu-bootcamp-app/frontend-tier/nginx/default.conf',
     require => Exec['git clone']
     }

    exec { 'install repo':
      command => '/usr/bin/curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -',
      require => File['/tmp/cmbu-bootcamp-app/frontend-tier/src/app/app.component.html']
      }

    exec { 'install node':
      command => '/usr/bin/apt install nodejs',
      require => Exec['install repo']
      }

    exec { '@angular/cli':
       command   => '/usr/bin/npm install -g @angular/cli',
       require => Exec['install node']
       }

   exec { 'npm install --unsafe-perm':
	command => '/usr/bin/npm install',
	cwd	=> '/tmp/cmbu-bootcamp-app/frontend-tier',
	creates	=> '/tmp/cmbu-bootcamp-app/frontend-tier/node_modules',
	require	=> Exec['@angular/cli']
	}

   exec { 'ng build --prod':
     command => '/usr/bin/ng build --prod',
     cwd     => '/tmp/cmbu-bootcamp-app/frontend-tier',
     creates => '/tmp/cmbu-bootcamp-app/frontend-tier/dist',
     require => Exec['npm install --unsafe-perm']
     }

   file { '/usr/share/nginx/html':
        ensure => 'directory',
        source => '/tmp/cmbu-bootcamp-app/frontend-tier/dist/cmbu-bootcamp-app',
        recurse => true,
        force => true,
	require => Exec['ng build --prod']
        }

}
}
