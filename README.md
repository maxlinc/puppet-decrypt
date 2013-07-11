**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Puppet-Decrypt](#puppet-decrypt)
	- [Comparison with Hiera-GPG](#comparison-with-hiera-gpg)
	- [Installation](#installation)
	- [Usage](#usage)
		- [Basic Usage](#basic-usage)
		- [Overriding the secret key](#overriding-the-secret-key)
	- [Contributing](#contributing)

# Puppet-Decrypt

*Notice: The default secret key location is now /etc/puppet-decrypt/encryptor_secret_key*

Puppet Decrypt is a gem that gives puppet the ability to encrypt and decrypt strings.  This is useful for making sure secret data - like database passwords - remains secret.  It uses a model similar to [jasypt Encrypting Application Configuration Files](http://www.jasypt.org/encrypting-configuration.html) or [Maven Password Encryption](http://maven.apache.org/guides/mini/guide-encryption.html).  It is a simple alternative to the [Secret variables in Puppet with Hiera and GPG](http://www.craigdunn.org/2011/10/secret-variables-in-puppet-with-hiera-and-gpg/) approach.

## Comparison with Hiera-GPG

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

### Basic Usage
Put the secret key in /etc/puppet-decrypt/encryptor_secret_key on machines where puppet needs to decrypt the value.  Make sure the file's read permissions are restricted!

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

### Overriding the secret key

Puppet Decrypt now supports using more than just the default secret key location.  You can easily use multiple secret keys for the same project.

For the Puppet face, you just use the --secretkey option to pass an alternate secret key location.

``` shell
$ echo 'example' > alt_key.txt
$ puppet crypt encrypt abc123 --secretkey alt_key
ENC[c4S4hMCDv1b7FkZgOBRTOA==]
$ puppet crypt decrypt ENC[c4S4hMCDv1b7FkZgOBRTOA==] --secretkey alt_key
abc123
```

There are two ways to use the alternate keys from the function.  You can pass it it as part of the string in this format:
``` yaml
database_password: ENC:alt_key[c4S4hMCDv1b7FkZgOBRTOA==]
```

If you do that, instead of using the default secret key, it will look for alt_key in the same directory.  So instead of
/etc/puppet-decrypt/encryptor_secret_key it will use /etc/puppet-decrypt/alt_key.

Alternately, you can pass a hash to the function, containing a value and a secret key, like this:
``` yaml
db_password:
  value: 'ENC[G6MjBDDFcapYLaKBFJvPSg==]'
  secretkey: '/any/path/you/another/key'
```

This has the advantage of letting you place keys in alternate directories, not just /etc/puppet-decrypt.

If you use this alongside hiera, you can just switch the lookup from hiera to hiera-hash:
``` ruby
decrypt(hiera_hash('db_password'))
```

See [features/hiera.feature](features/hiera.feature) for complete examples.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
