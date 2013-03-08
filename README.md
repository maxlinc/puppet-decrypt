[![Build Status](https://secure.travis-ci.org/maxlinc/puppet-decrypt.png?branch=master)](http://travis-ci.org/maxlinc/puppet-decrypt)
[![Dependency Status](https://gemnasium.com/maxlinc/puppet-decrypt.png?travis)](https://gemnasium.com/maxlinc/puppet-decrypt)
[![Code Climate](https://codeclimate.com/github/maxlinc/puppet-decrypt.png)](https://codeclimate.com/github/maxlinc/puppet-decrypt)

# Puppet-Decrypt

Puppet Decrypt is a gem that gives puppet the ability to encrypt and decrypt strings.  This is useful for making sure secret data - like database passwords - remains secret.  It uses a model similar to [jasypt Encrypting Application Configuration Files](http://www.jasypt.org/encrypting-configuration.html) or [Maven Password Encryption](http://maven.apache.org/guides/mini/guide-encryption.html).  It is a simple alternative to the [Secret variables in Puppet with Hiera and GPG](http://www.craigdunn.org/2011/10/secret-variables-in-puppet-with-hiera-and-gpg/) approach.

# Comparison with Hiera-GPG

Advantages:

* Store encrypted secret variables and related non-secret variables in the same file.
* Version control friendly - you can easily see when a variable was added, changed, or removed even if you don't know the exact value.
* Works with any data source.  Combine it with Hiera, extlookup, external node classifiers, exported resources, or any other source of data.
* Simple administration - no keyring management.

Disadvantages:

* Uses a shared secret instead of asymetric keypairs.  This means that the "master password" is shared by all admins.  It is also shared by all machines that need to decrypt the same value (usually machines in the same environment).
* Less integrated with Hiera.  You need to wrap calls as decrypt(hiera('my_db_password')).

The shared secret "master password" may seem more difficult to grant and revoke access than the asymetric keypair approach used by hiera-gpg.  However both systems are protecting shared secret data!  So if you want to fully revoke someone's access you need to change or revoke their decryption key (which is easier with hiera-gpg) *AND* to change any secrets that key protected (e.g.: your production database passwords).

## Installation

Add this line to your application's Gemfile:

    gem 'puppet-decrypt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puppet-decrypt

## Usage

Put the secret key in /etc/encryptor_secret_key on machines where puppet needs to decrypt the value.  Make sure the file's read permissions are restricted!

Use the puppet face to encrypt a value

``` shell
$ puppet crypt encrypt my_secret_value
ENC[ANN3I3AWxXWmr5QAW3qgxw==]
```

Or to decrypt a value
``` shell
$ puppet crypt decrypt ENC[ANN3I3AWxXWmr5QAW3qgxw==]
my_secret_value
```

Put that value into hiera, extlookup, or any other data source you want.  Hiera example:
``` yaml
database_password: ENC[ANN3I3AWxXWmr5QAW3qgxw==]
```

In your puppet code, load the value normally and then pass it to decrypt.
``` ruby
decrypt(hiera('database_password'))
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
