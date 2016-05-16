puppet-wkhtmltopdf
===============
Puppet module to install Wkhtmltopdf. Nothing fancy yet, it handles only the installation.

Installation
------------
###### Installation using the Puppet Module Tool
```
puppet module install eymengunay/wkhtmltopdf
```

###### Installation via git submodule
```
git submodule add https://github.com/eymengunay/puppet-wkhtmltopdf.git ./modules/wkhtmltopdf
```

Usage
------------
```
class { 'wkhtmltopdf': }
```

License
------------
This module is released under [MIT license](LICENSE).
