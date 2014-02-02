## 0.1.1 (Jan 24, 2014)

Bugfixes:

  - Add Ruby 1.8.7 support.

## 0.1.0 (July 10, 2013)

Features:

  - support alternate secret keys
    - override the key as part of the string in the format ENC:another_key[...]
    - override the key by passing a hash containing value and secret_key

Bugfixes:

  - Explicitly remove Ruby 1.8.7 support.  Previously it would install but not work with Ruby 1.8.7.

## 0.0.4 (March 8, 2013)

Features:

  - puppet face for encrypting/decrypting secrets
  - basic puppet function for decrypting a secret, using a master key
